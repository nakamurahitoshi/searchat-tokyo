# searchat-tokyo DB設計

## stationsテーブル
|Column|Type|Options|
|------|----|-------|
|name|string|null: false, unique: true, default: false, primary_key: true, foreign_key: false, index: true|
|lat|double|null: false, unique: true, default: false, primary_key: true, foreign_key: false, index: false|
|lng|double|null: false, unique: true, default: false, primary_key: true, foreign_key: false, index: false|

### アソシエーション
- has_many :users
- has_many :railways, through: :stations_railways