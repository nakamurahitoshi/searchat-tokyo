# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
# csvファイルから路線・駅データをインポート
require "csv"

stations_csv = CSV.readlines("db/stations.csv")
railways_csv = CSV.readlines("db/railways.csv")

# 取り込み
stations_csv.each do |row|
  Station.create(name: row[1], lat: row[2], lng: row[3])
end
railways_csv.each do |row|
  Railway.create(name: row[1], odptrailway: row[2])
end