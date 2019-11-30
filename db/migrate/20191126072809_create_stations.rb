class CreateStations < ActiveRecord::Migration[5.2]
  def change
    create_table :stations do |t|
      t.string :name, null: false, unique: true
      t.float :lat, limit: 53, null: false
      t.float :lng, limit: 53,	null: false
      t.timestamps
    end
    add_index :stations, :name
  end
end
