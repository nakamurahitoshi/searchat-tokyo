class StationsController < ApplicationController
include StationsHelper
  # 駅名のインクリメンタルサーチを行うindexアクション
  def index
    # ユーザが駅名を入力したら、その駅名を含む(前方一致)駅データをstationsテーブルから抽出する
    # 何も入力していない場合はnilを返す
    params.permit(:station_name_input)
    input = params[:station_name_input]
    if input == ""
      return nil
    else
      # 部分一致した駅を表示(最大10件)
      @stations = Station.where(["name LIKE ?", "#{input}%"] ).limit(10)
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

  # 最寄駅を検索するためにDBから駅を取得するアクション
  def search
    # ajaxから現在位置の緯度経度が送られる
    # 緯度経度それぞれ±0.1度(約10km)の範囲の駅を取得
    params.permit(:lat, :lng)
    lat = params[:lat].to_f
    lng = params[:lng].to_f
    @stations = Station.where("lat BETWEEN ? and ? AND lng BETWEEN ? and ?", (lat - 0.1), (lat + 0.1), (lng - 0.1), (lng + 0.1))
    # 現在地から最も近い距離にある駅を検索する
    @station = search_nearest_station(lat, lng, @stations)
    # jsonのリクエストに応じてレスポンスを返す
    respond_to do |format|
      format.json
    end
  end
end