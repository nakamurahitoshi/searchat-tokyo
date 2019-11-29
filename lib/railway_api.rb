require "train_api.rb"
# 路線に関するリクエスト文を作成
class RailwayAPI < TrainAPI
  PATH = 'Railway'
  def self.fetch(params)
    make_get_request(PATH, params)
  end
end