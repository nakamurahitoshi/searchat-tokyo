module StationsHelper
  # APIにより全部の駅を取得し、既存データとの差分があれば更新するrefreshメソッド
  def refreshStations
    # 全ての駅を取得し、配列で返す
    # [注]件数が多く一度に全件取得できないため、路線ごとに取得する
    
    # 路線全部を取得
    railways = Railway.all
    # 路線ごとに駅を取得
    railways.each do |railway|
      params =  {"odpt:railway": railway[:odptrailway]}
      res = StationAPI.fetch(params)
      station_list =  JSON.parse(res.body)
      # 取得した駅一覧をDBに格納する
      station_list.each do |station|
        # 取得した駅と対応する既存データの駅を駅名により紐づける
        existing_station = Station.find_by(name: station["odpt:stationTitle"]["ja"])
        if existing_station == nil
          # DBに既存のレコードが存在しなければ、新たに駅オブジェクトを作成し、登録する
          new_station = Station.new
          fetch_station_column(new_station, station)
          new_station.save
        else
          # DBに既存のレコードが存在していれば、そのレコードの各カラムを更新する
          fetch_station_column(existing_station, station)
        end
      end
    end
  end

  # APIにより路線に対する駅の順序情報を全て取得し
  # 既存データとの差分があれば更新するrefreshメソッド
  def refreshStationRailways
    # 全ての路線を取得し、配列で返す
    res = RailwayAPI.fetch({})
    railway_list =  JSON.parse(res.body)
    # 取得した路線に対する駅の順番をDBに格納する
    railway_list.each do |railway|
      # 既存の路線レコードを取得
      existing_railway = Railway.find_by(odptrailway: railway["owl:sameAs"])
      
      #路線に対し駅を紐づける
      railway["odpt:stationOrder"].each do |station|
        # その路線の駅のデータベースレコードを取得
        existing_station = Station.find_by(name: station["odpt:stationTitle"]["ja"])

        # 中間テーブルからレコードを取り出す
        new_station_railway = StationRailway.where("station_id = ? and railway_id = ?", existing_station.id, existing_railway.id)
        if new_station_railway == []
          # 中間テーブルのレコードがまだ存在しなければ、生成する
          new_station_railway = StationRailway.new(station_id: existing_station.id, railway_id: existing_railway.id, order: station["odpt:index"])
          new_station_railway.save
        else
          # 中間テーブルのレコードがすでに存在していれば駅の順番だけ更新する
          new_station_railway[0].order = station["odpt:index"]
        end
      end
    end
  end

  # 現在地の緯度経度をもとに、近くにある駅を検索する
  def search_nearby_station(now_lat, now_lng, stations)
    # 検索する最寄駅数。
    station_num = 3
    # 距離とインデクスを格納しておく変数
    stations_indexes = []
    stations.each_with_index do |station, i|
      st_lat = station.lat.to_f
      st_lng = station.lng.to_f
      # 緯度・経度を元に2地点間の距離を計算(km->mに変換して)
      dist = calcDist(st_lat, st_lng, now_lat, now_lng) * 1000
      #dist = Math.sqrt((st_lat - now_lat)*(st_lat - now_lat) + (st_lng - now_lng) * (st_lng - now_lng))
      stations_indexes << {dist: dist,index: i}
    end
    # 現在地から近い順にstation_num個の駅を返戻する
    # ソート
    stations_indexes.sort!{|a,b| a[:dist]<=>b[:dist]}
    # 返す駅の配列
    return_stations = Array.new(station_num)
    for i in 0..station_num-1 do
      if stations_indexes[i] != nil
        # 駅オブジェクトと駅までの距離を配列に格納
        return_stations[i] = {stobj: stations[stations_indexes[i][:index]], dist:stations_indexes[i][:dist]}
      else
        return_stations[i] = nil
      end
    end
    return return_stations
  end

  private
  def fetch_station_column(station_obj, station)
    # DBの各カラムを記述or更新する
    station_obj.name = station["dc:title"]
    if station["geo:lat"] == nil
      # 緯度・経度情報が無ければ、
      # HeartRailsExpressサイトのAPIを使い、緯度経度を取得
      url = "http://express.heartrails.com/api/json?method=getStations"
      params =  {"name": station_obj.name}
      res = ExternalAPI.make_get_request(url, params)
      lat_long_res = JSON.parse(res.body)
      station_obj.lat = lat_long_res["response"]["station"][0]["x"]
      station_obj.lng = lat_long_res["response"]["station"][0]["y"]
    else
      station_obj.lat = station["geo:lat"]
      station_obj.lng = station["geo:long"]
    end
  end
end
