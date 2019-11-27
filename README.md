# searchat-tokyo DB設計

## stationsテーブル
|Column|Type|Options|
|------|----|-------|
|name|string|null: false, unique: true, default: false, primary_key: false, foreign_key: false, index: true|
|lat|double|null: false, unique: true, default: false, primary_key: false, foreign_key: false, index: false|
|lng|double|null: false, unique: true, default: false, primary_key: false, foreign_key: false, index: false|
### アソシエーション
- has_many :users
- has_many :railways, through: :stations_railways

## railwaysテーブル
|Column|Type|Options|
|------|----|-------|
|name|string|null :false, unique :true, default :false; primary_key :false, foreign_key :false, index:false|
### アソシエーション
- has_many :stations, through: :stations_railways

## stations_railwaysテーブル
|Column|Type|Options|
|------|----|-------|
|station_id|integer|null: false, unique: true, default: false, primary_key: false, foreign_key: true, index: false|
|railway_id|integer|null: false, unique: true, default: false, primary_key: false, foreign_key: true, index: false|
|order|integer|null: false, unique: false, default: false, primary_key: false, foreign_key: false, index: false|
### アソシエーション
- belongs_to :stations
- belongs_to :railways

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

## usersテーブル
|Column|Type|Options|
|------|----|-------|
|name|string|null: false, unique: false, default: false, primary_key: false, foreign_key: false, index: false|
|email|string|null: false, unique: true, default: "", primary_key: false, foreign_key: false, index: false|
|encrypted_password|string|null: false, unique: false, default: "", primary_key: false, foreign_key: false, index: false|
|point|integer|null: false, unique: false, default: false, primary_key: false, foreign_key: false, index: false|
|station_id|integer|null: true, unique: false, default: null, primary_key: false, foreign_key: true, index: false|
### アソシエーション
- has_many :messages
- belongs_to :stations