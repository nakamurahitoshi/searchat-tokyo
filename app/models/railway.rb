class Railway < ApplicationRecord
  has_many :stations, through: :stations_railways
  has_many :stations_railways
  validates :name, presence: true, uniqueness: true

  # APIにより全部の路線を取得し、既存データとの差分があれば更新するrefreshメソッド
  def refresh
    # 全ての路線を取得し、配列で返す
    res = RailwayAPI.fetch({})
    railway_list =  JSON.parse(res.body)

    # 取得した路線一覧をDBに格納する
    railway_list.each do |railway|
      # 取得した路線と対応する既存データの路線を識別コードucodeにより紐づける
      existing_railway = this.find_by(ucode: railway["@id"])
      if existing_railway == nil
        # DBに既存のレコードが存在しなければ、新たに路線オブジェクトを作成し、登録する
        new_railway = this.new
        fetch_railway_column(new_railway, railway)
        railway.save
      else
        # DBに既存のレコードが存在していれば、そのレコードの各カラムを更新する
        fetch_railway_column(existing_railway, railway)
      end
    end
  end

  private
  def fetch_railway_column(railway_obj, railway)
    # DBの各カラムを記述or更新する
    railway_obj.name = railway["dctitle"]
    railway_obj.ucode = railway["@id"]
  end

end