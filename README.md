# searchat-tokyo DB設計

## comment table
|Column|Type|Options|
|------|----|-------|
|body|string|null :false, unique :false, defaultrt :false; primary_key :false, foreign_key :false, index:false|
|date|int|null :false, unique :false, default :false; primary_key :false, foreign_key :false, index:false|
|user_id|int|null :false, unique :false, default :false; primary_key :false, foreign_key :true, index:false|
|station_id|int|null :false, unique :false, default :false; primary_key :false, foreign_key :true, index:false|

### Association
- belongs_to :user
- belongs_to :station


## comment table
|Column|Type|Options|
|------|----|-------|
|name|string|null :false, unique :true, default :false; primary_key :false, foreign_key :true, index:false|

### Association
- has_many :stations, through: :stations_railways


## stationsテーブル
|Column|Type|Options|
|------|----|-------|
|name|string|null: false, unique: true, default: false, primary_key: true, foreign_key: false, index: true|
|lat|double|null: false, unique: true, default: false, primary_key: true, foreign_key: false, index: false|
|lng|double|null: false, unique: true, default: false, primary_key: true, foreign_key: false, index: false|

### アソシエーション
- has_many :users
- has_many :railways, through: :stations_railways

