class CreateStations < ActiveRecord::Migration[5.2]
  def change
    create_table :stations do |t|
      t.string :name, null: false, unique: true, index: true
      t.float :lat, limit: 53, null: false, unique: true
      t.float :lng, limit: 53,	null: false, unique: true
      t.timestamps
    end
  end
end
