class CreateRailways < ActiveRecord::Migration[5.2]
  def change
    create_table :railways do |t|

      t.timestamps
    end
  end
end
