class RailwaysController < ApplicationController
  include StationsHelper
  include RailwaysHelper

  # トップページを表示するindexアクション
  def index  
  end
  # DBの中身を更新するupdateアクション
  def update
    # stationsテーブルを更新
    view_context.refreshRailways
    
    # stationsテーブルとstations_railwaysテーブルを更新
    view_context.refreshStations

    # station_railwaysテーブルを更新
    view_context.refreshStationRailways

    redirect_to railways_path, notice: "駅・路線のデータベースを更新しました"
  end
end
