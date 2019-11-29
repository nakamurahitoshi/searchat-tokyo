class Station < ApplicationRecord
  has_many :users
  has_many :railways, through: :stations_railways
  has_many :stations_railways
  validates :name, presence: true, uniqueness: true
  validates :lat, presence: true, uniqueness: true
  validates :lng, presence: true, uniqueness: true

  # APIにより全部の駅を取得し、既存データとの差分があれば更新するrefreshメソッド
  def refresh
    # 全ての駅を取得し、配列で返す
    res = StationAPI.fetch({})
    station_list =  JSON.parse(res.body)

    # 取得した駅一覧をDBに格納する
    station_list.each do |station|
      # 取得した駅と対応する既存データの駅を識別コードucodeにより紐づける
      existing_station = this.find_by(ucode: station["@id"])
      if existing_station == nil
        # DBに既存のレコードが存在しなければ、新たに駅オブジェクトを作成し、登録する
        new_station = this.new
        fetch_station_column(new_station, station)
        new_station.save
      else
        # DBに既存のレコードが存在していれば、そのレコードの各カラムを更新する
        fetch_station_column(existing_station, station)
      end
    end
  end

  private
  def fetch_station_column(station_obj, station)
    # DBの各カラムを記述or更新する
    station_obj.name = station["dctitle"]
    if station["geo_lat"] == nil
      # 緯度・経度情報が無ければ、
      # HeartRailsExpressサイトのAPIを使い、緯度経度を取得
      url = "http://express.heartrails.com/api/json?method=getStations"
      params =  {"name" : URI.encode(new_station.name)}
      res = API.make_get_request(url, params)
      lat_long_res = JSON.parse(res.body)
      station_obj.lat = lat_long_res["response"]["station"][0]["x"]
      station_obj.lng = lat_long_res["response"]["station"][0]["y"]
    else
      station_obj.lat = station["geo_lat"]
      station_obj.lng = station["geo_long"]
    end
    station_obj.ucode = station["@id"]
  end
end
