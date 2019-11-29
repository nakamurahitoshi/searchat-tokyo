class StationRailway < ApplicationRecord
  belongs_to :station
  belongs_to :railway
  validates :order, presence: true

  # APIにより路線に対する駅の順序情報を全て取得し
  # 既存データとの差分があれば更新するrefreshメソッド
  def refresh
    # 全ての路線を取得し、配列で返す
    res = RailwayAPI.fetch({})
    railway_list =  JSON.parse(res.body)

    # 取得した路線に対する駅の順番をDBに格納する
    railway_list.each do |railway|
      # 既存の路線レコードを取得
      existing_railway = this.find_by(ucode: railway["@id"])
      
      railway["odpt:stationOrder"].each do |station|
        #路線に対し既存の駅を紐づける
        existing_station = Station.find_by(name: station["odpt:stationTitle"]["ja"])

        # 中間テーブルからレコードを取り出す
        new_station_railway = this.where("station_id = ? and railway_id = ?", existing_station.id, existing_railway.id)

        if new_station_railway == nil
          # 中間テーブルを生成する
          existing_railway.station  << existing_station
          # 中間テーブルからレコードを取り出す
          new_station_railway = this.where("station_id = ? and railway_id = ?", existing_station.id, existing_railway.id)
        end
        # 駅の順番を書き込む
        new_station_railway.order = station["odpt:index"]
      end
    end
  end
end