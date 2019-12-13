class MessagesController < ApplicationController
  # 路線図と駅チャット画面を表示するindexアクション
  def index
    @message = Message.new
    # 駅情報を取得
    @station = set_station
    @messages = @station.messages
    # その駅の属する路線の情報を全て取得
    @railways = @station.railways
    # 路線ごとに、その駅の前後2駅を取得。多次元で実装する。
    # 例: [東海道線[東京,新橋,品川...], 山手線[秋葉原,神田,東京,有楽町,新橋],...]
    @stations = Array.new(@railways.length)
    for i in 0..@stations.length-1
      # その路線における、ユーザが選択した駅の順番
      station_railways_id = @station.station_railways.where("railway_id = ?", @railways[i].id).pluck(:order)[0]
      @stations[i] = Station.joins(:station_railways).where("station_railways.railway_id = ? AND station_railways.order BETWEEN ? AND ? " , @railways[i].id, station_railways_id-2, station_railways_id+2)

      # 山手線の例外処理
      if @railways[i].odptrailway == "odpt.Railway:JR-East.Yamanote"
        #駅配列先頭が大崎かつ長さが5に満たない場合は、満たすまで先頭から、最終駅から順に付加してゆく
        if (@stations[i][0].name == "大崎") && @stations[i].length < 5
          for j in 0..(4-@stations[i].length)
            station_order = @railways[i].station_railways.maximum(:order) - j
            add_station = Station.find(@railways[i].station_railways.find_by(order: station_order).station_id)
            @stations[i] = [add_station] + @stations[i]
          end
        end

        #駅配列最後が品川かつ長さが5に満たない場合は、満たすまで最後から、最終駅から順に付加してゆく
        if (@stations[i][@stations[i].length-1].name == "品川") && @stations[i].length < 5
          for j in 0..(4-@stations[i].length)
            station_order = 1 + j
            add_station = Station.find(@railways[i].station_railways.find_by(order: station_order).station_id)
            @stations[i] = @stations[i]+[add_station]
          end
        end
      end
    end

    # 各路線の始発駅・終着駅を独自で持たせる
    # 例: [東海道線[first:東京,last:熱海], ...]
    @first_last_station = Array.new(@railways.length)
    for i in 0..@first_last_station.length-1
      # その路線の始発駅id
      first_st_order = @railways[i].station_railways.minimum(:order)
      first_station_id = @railways[i].station_railways.find_by(order: first_st_order).station_id
      # その路線の終着駅id
      last_st_order = @railways[i].station_railways.maximum(:order)
      last_station_id = @railways[i].station_railways.find_by(order: last_st_order).station_id
      # 始発・終着駅の取得
      @first_last_station[i] = {first: Station.find(first_station_id), last: Station.find(last_station_id)}
    end


  end

  # 駅チャットの投稿を保存するcreateアクション
  def create
    # 駅情報を取得
    @station = set_station
    # メッセージオブジェクトを作成
    @message = @station.messages.new(message_params)
    
    # メッセージが保存できた場合とできなかった場合それぞれで、リクエストに応じたレスポンスを返す
    if @message.save
      respond_to do |format|
        format.html{
          redirect_to station_messages_path(@station), notice: "メッセージが送信されました"
        }
        format.json
      end
    else
      respond_to do |format|
        format.html{
          @messages = @station.messages.includes(:user)
          flash.now[:alert] = "メッセージを入力してください。"
          render :index
        }
        format.json 
      end
    end
  end

  # 投稿ユーザにポイントを加算し地図と目的地を表示するshowアクション
  def show
    user = User.find((params.permit(:user_id))[:user_id])
    # 行き先の名称
    destination = (params.permit(:keyword))[:keyword]
    # 駅名ID
    station_id = (params.permit(:station_id))[:station_id]
    # 駅名
    station_name = Station.find(station_id).name
    # 行き先名に現在の駅を追加したものをキーワードとする
    destination_with_station_name = destination + " " + station_name

    # 自分自身にはポイントを付与せずにリダイレクト
    if current_user.id == user.id
      # statonsコントローラ#showアクションにハッシュタグ文+駅名を渡してリダイレクトする
      redirect_to station_path(destination: destination_with_station_name)
    else
      # メッセージID
      message_id = (params.permit(:message_id))[:message_id]
      # この投稿に自分がポイントを付与した実績がなければ、ポイントを付与
      is_gave = UserMessage.where("user_id = ? and message_id = ?", current_user.id, message_id)
      if is_gave == [] 
        # 投稿ユーザにポイントを1加算
        user.point = user.point + 1
        user.save
        # 付与した実績をテーブルに追加
        new_user_message = UserMessage.create(user_id: current_user.id, message_id: message_id.to_i, is_gave: true)
      elsif !(is_gave[0].is_gave)
        # 投稿ユーザにポイントを1加算
        user.point = user.point + 1
        user.save
        # 付与した実績でカラムを更新
        is_gave.is_gave = true
        is_gave.save
      end 
      # statonsコントローラ#showアクションにハッシュタグ文+駅名を渡してリダイレクトする
      redirect_to station_path(destination: destination_with_station_name)
    end
  end

  def destroy
    message = Message.find(params[:id])
    message.destroy
    respond_to do |format|
      format.html{
        redirect_to station_messages_path(params[:station_id])
      }
      format.json 
    end
  end

  # name=station[:name]というタグに入力された文字が送信されるため、このような取得方法が必要
  private
  def set_station
    # ユーザが検索した駅の情報を取得
    stname = params.permit(:station_id)
    station = Station.find(stname[:station_id])
    return station
  end

  def message_params
    params.require(:message).permit(:body).merge(params.permit(:station_id)).merge(user_id: current_user.id)
  end
end