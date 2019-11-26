## stations_railwaysテーブル
|Column|Type|Options|
|------|----|-------|
|order|integer|null: false, unique: true, default: false, primary_key: false, foreign_key: false, index: false|
|station_id|integer|null: false, unique: true, default: false, primary_key: false, foreign_key: true, index: false|
|railway_id|integer|null: false, unique: true, default: false, primary_key: false, foreign_key: true, index: false|
### Association
- belongs_to :stations
- belongs_to :railways

## usersテーブル
|Column|Type|Options|
|------|----|-------|
|name|string|null: false, unique: false, default: false, primary_key: false, foreign_key: false, index: false|
|email|string|null: false, unique: true, default: false, primary_key: false, foreign_key: false, index: false|
|password|string|null: false, unique: false, default: false, primary_key: false, foreign_key: false, index: false|
|point|integer|null: false, unique: faalse, default: false, primary_key: false, foreign_key: false, index: false|
|station_id|integer|null: true, unique: false, default: true, primary_key: false, foreign_key: true, index: false|
### Association
- has_many :comments
- belongs_to :stations