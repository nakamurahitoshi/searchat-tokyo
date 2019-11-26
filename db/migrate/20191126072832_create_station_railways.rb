class CreateStationRailways < ActiveRecord::Migration[5.2]
  def change
    create_table :station_railways do |t|

      t.timestamps
    end
  end
end
