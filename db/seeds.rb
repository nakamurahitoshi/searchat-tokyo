# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
# 駅データを作成
Station.create!(
  [
    {
      name: "東京",
      lat: 35.681935,
      lng: 139.7648,
      ucode: "urn:ucode:_00001C000000000000010000031027F1",
    },
    {
      name: "横浜",
      lat: 35.465264,
      lng: 139.622848,
      ucode: "urn:ucode:_00001C00000000000001000003102108",
    }
  ]
)

# 路線データを作成
Railway.create!(
  [
    {
      name: "東海道線",
      ucode: "urn:ucode:_00001C00000000000001000003100E25",
    },
    {
      name: "総武快速線",
      ucode: "urn:ucode:_00001C00000000000001000003100E1D",
    }
  ]
)

# 路線・駅データを作成
StationRailway.create!(
  [
    {
      station_id: 1,
      railway_id: 1,
      order: 1,
    },
    {
      station_id: 1,
      railway_id: 2,
      order: 1,
    },
    {
      station_id: 2,
      railway_id: 1,
      order: 5,
    }
  ]
)

Message.create!(
  [
    {
      body: "こんにちは",
      user_id: 1,
      station_id: 1,
    }
  ]
)