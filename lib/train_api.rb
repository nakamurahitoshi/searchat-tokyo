require 'faraday'
require 'json'
class TrainAPI
  BASE_URL = 'https://api-tokyochallenge.odpt.org/api/v4/odpt:'
  CONSUMER_KEY = Rails.application.credentials.consumer_key
  
  # リクエスト文を作成する
  def self.make_get_request(path, params)
    # pathには'TrainTimetable'などのデータ種別が入る
    # paramsにはオプション情報のハッシュ
    # (例:{'odpt:operator': 'odpt.Operator:JR-East'})
    url = BASE_URL + path
    conn = Faraday.new(url)
    # リクエスト文作成
    res = conn.get do |req|
      req.params['acl:consumerKey'] = CONSUMER_KEY
      params.each do |key, value|
        req.params[key] = value
      end
    end
    return res
  end
end
