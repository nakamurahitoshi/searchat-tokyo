class RailwaysController < ApplicationController
  # トップページを表示するindexアクション
  def index  
  end
  # DBの中身を更新するupdateアクション
  def update
    # stationsテーブルを更新
    Station.refresh
    # railwaysテーブルを更新
    Railway.refresh
    # stations_railwaysテーブルを更新
    StationRailway.refresh
  end
end
