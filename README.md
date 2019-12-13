# searchat-tokyo DB設計

## stationsテーブル
|Column|Type|Options|
|------|----|-------|
|name|string|null: false, unique: true, default: false, primary_key: false, foreign_key: false, index: true|
|lat|double|null: false, unique: false, default: false, primary_key: false, foreign_key: false, index: false|
|lng|double|null: false, unique: false, default: false, primary_key: false, foreign_key: false, index: false|
### アソシエーション
- has_many :users
- has_many :railways, through: :stations_railways

## railwaysテーブル
|Column|Type|Options|
|------|----|-------|
|name|string|null :false, unique :false, default :false; primary_key :false, foreign_key :false, index:false|
|odptrailway|string|null: false, unique: true, default: false, primary_key: false, foreign_key: false, index: true|
### アソシエーション
- has_many :stations, through: :stations_railways

## station_railwaysテーブル
|Column|Type|Options|
|------|----|-------|
|station_id|integer|null: false, unique: true, default: false, primary_key: false, foreign_key: true, index: false|
|railway_id|integer|null: false, unique: true, default: false, primary_key: false, foreign_key: true, index: false|
|order|integer|null: false, unique: false, default: false, primary_key: false, foreign_key: false, index: false|
### アソシエーション
- belongs_to :stations
- belongs_to :railways

## usersテーブル
|Column|Type|Options|
|------|----|-------|
|name|string|null: false, unique: false, default: false, primary_key: false, foreign_key: false, index: false|
|email|string|null: false, unique: true, default: "", primary_key: false, foreign_key: false, index: false|
|encrypted_password|string|null: false, unique: false, default: "", primary_key: false, foreign_key: false, index: false|
|point|integer|null: false, unique: false, default: false, primary_key: false, foreign_key: false, index: false|
|station_id|integer|null: true, unique: false, default: null, primary_key: false, foreign_key: true, index: false|
|admin|boolean|null: true, unique: false, default: false, primary_key: false, foreign_key: false, index: false|
### アソシエーション
- has_many :messages
- belongs_to :stations

## messagesテーブル
|Column|Type|Options|
|------|----|-------|
|body|string|null: false, unique: false, default: false, primary_key: false, foreign_key: false, index: false|
|created_at|int|null: false, unique: false, default: false, primary_key: false, foreign_key: false, index: false|
|user_id|int|null: false, unique: false, default: false, primary_key: false, foreign_key: true, index: false|
|station_id|int|null: false, unique: false, default: false, primary_key: false, foreign_key: true, index: false|
### アソシエーション
- belongs_to :user
- belongs_to :station

## user_messagesテーブル
|Column|Type|Options|
|------|----|-------|
|user_id|int|null: false, unique: false, default: false, primary_key: false, foreign_key: true, index: false|
|message_id|int|null: false, unique: false, default: false, primary_key: false, foreign_key: true, index: false|
|is_gave|boolean|null: false, unique: false, default: false, primary_key: false, foreign_key: false, index: false|
### アソシエーション
- has_many :users
- has_many :messages