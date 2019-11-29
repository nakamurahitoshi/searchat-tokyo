class RenameStationrailwaysToStationsrailways < ActiveRecord::Migration[5.2]
  def change
    rename_table :station_railways, :stations_railways
  end
end
