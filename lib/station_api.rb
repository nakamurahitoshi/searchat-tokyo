require "train_api.rb"
# 駅に関するリクエスト文を作成
class StationAPI < TrainAPI
  PATH = 'Station'
  def self.fetch(params)
    make_get_request(PATH, params)
  end
end