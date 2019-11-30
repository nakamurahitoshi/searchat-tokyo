module RailwaysHelper
  # APIにより全部の路線を取得し、既存データとの差分があれば更新するrefreshメソッド
  def refreshRailways
    # 全ての路線を取得し、配列で返す
    res = RailwayAPI.fetch({})
    railway_list =  JSON.parse(res.body)
    # 取得した路線一覧をDBに格納する
    railway_list.each do |railway|
      # 取得した路線と対応する既存データの路線を識別コードucodeにより紐づける
      existing_railway = Railway.find_by(odptrailway: railway["owl:sameAs"])
      if existing_railway == nil
        # DBに既存のレコードが存在しなければ、新たに路線オブジェクトを作成し、登録する
        new_railway = Railway.new
        fetch_railway_column(new_railway, railway)
        new_railway.save
      else
        # DBに既存のレコードが存在していれば、そのレコードの各カラムを更新する
        fetch_railway_column(existing_railway, railway)
      end
    end
  end
  private
  def fetch_railway_column(railway_obj, railway)
    # DBの各カラムを記述or更新する
    railway_obj.name = railway["dc:title"]
    railway_obj.odptrailway = railway["owl:sameAs"]
  end
end
