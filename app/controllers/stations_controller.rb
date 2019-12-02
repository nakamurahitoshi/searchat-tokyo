class StationsController < ApplicationController
  # インクリメンタルサーチを行うindexアクション
  def index
    # ユーザが駅名を入力したら、その駅名を含む駅データをstationsテーブルから抽出する
    # 何も入力していない場合はnilを返す
    if params[:station_name] == ""
      return nil
    else
      # 部分一致した駅を表示
      @stations = Station.where(["name LIKE ?", "%#{params[:station_name]}%"] ).limit(10)
      
      # html,jsonのリクエストに応じてレスポンスを返す
      respond_to do |format|
        format.html
        format.json
      end
    end
  end

  # 行き先地と地図を表示させるshowアクション
  def show
    # 行き先を変数に格納。@destination[:destination]で取り出せる
    # この変数をJavascriptで扱うようにする
    @destination = params.permit(:destination)
  end
end