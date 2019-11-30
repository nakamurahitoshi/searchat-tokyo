class CreateRailways < ActiveRecord::Migration[5.2]
  def change
    create_table :railways do |t|
      t.string :name, null: false
      t.string :odptrailway, null: false, unique: true
      t.timestamps
    end
    add_index :railways, :odptrailway
  end
end
