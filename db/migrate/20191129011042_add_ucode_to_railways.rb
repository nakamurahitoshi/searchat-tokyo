class AddUcodeToRailways < ActiveRecord::Migration[5.2]
  def change
    add_column :railways, :ucode, :string
  end
end
