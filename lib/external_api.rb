require 'faraday'
require 'json'
# 東京公共交通API以外の物を使用するAPIのライブラリ
class ExternalAPI
  
  # リクエスト文を作成する
  def self.make_get_request(url, params)
    # pathはパラメータ部分を除いたリクエストのURL
    # paramsはリクエストで指定するハッシュ形式によるパラメータ
    conn = Faraday.new(url)
    # リクエスト文作成
    res = conn.get do |req|
      params.each do |key, value|
        req.params[key] = value
      end
    end
    return res
  end
end
