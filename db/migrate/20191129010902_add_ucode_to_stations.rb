class AddUcodeToStations < ActiveRecord::Migration[5.2]
  def change
    add_column :stations, :ucode, :string
  end
end
