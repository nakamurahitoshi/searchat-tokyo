class MessagesController < ApplicationController
  before_action :set_station
  # 路線図と駅チャット画面を表示するindexアクション
  def index  
    # その駅の属する路線の情報を全て取得
    @railways = @station.railways

    # 路線ごとに、その駅の前後2駅を取得。多次元で実装する。
    # 例: [東海道線[東京,新橋,品川...], 山手線[秋葉原,神田,東京,有楽町,新橋],...]
    @stations = Array.new(@railways.length)
    for i in 0..@stations.length-1
      # その路線における、ユーザが選択した駅の順番
      stations_railways_id = @station.stations_railways.where("railway_id = ?", @railways[i].id).select(:order)
      @stations[i] = @railways[i].join(:stations).where("stations_railways.order BETWEEN ? AND ? " , stations_railways_id-2, stations_railways_id+2)
    end
  end

  # 駅チャットの投稿を保存するcreateアクション
  def create
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
    # 投稿ユーザにポイントを1加算する
    user = User.find(params.permit(:user_id))
    user.point = user.point + 1
    user.save
    # statonsコントローラ#showアクションにハッシュタグ文を渡してリダイレクトする
    redirect_to station_path(destination: message_params[:body])
  end
  
  # name=station[:name]というタグに入力された文字が送信されるため、このような取得方法が必要
  private
  def set_station
    # ユーザが検索した駅の情報を取得
    @station = Station.find_by(station_params)
  end
  def station_params
    params.require(:station).permit(:name)
  end
  def message_params
    params.require(:message).permit(:body).merge(user_id: current_user.id)
  end
end
