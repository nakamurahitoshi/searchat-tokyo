class CreateStationRailways < ActiveRecord::Migration[5.2]
  def change
    create_table :station_railways do |t|
      t.references :station, foreign_key: true
      t.references :railway, foreign_key: true
      t.integer :order, null: false
      t.timestamps
    end
  end
end