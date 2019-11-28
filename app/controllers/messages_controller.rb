class MessagesController < ApplicationController
  # 路線図と駅チャット画面を表示するindexアクション
  def index  
    # ユーザが検索した駅の情報を取得
    @station = Station.find(station_params[:id])
    # その駅の属する路線の情報を取得
    # 路線ごとに、その駅の前後2駅を取得
  end

  def create
  end

  def show
  end
  
  # name=station[:name]というタグに入力された文字が送信されるため、このような取得方法が必要
  private
  def station_params
    params.require(:station).permit(:id)
  end
end
