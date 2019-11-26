class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :email, null: false, unique: true
      t.string :password, null: false
      t.integer :point, null: false
      t.references :station, default: nil, foreign_key: true
      t.timestamps
    end
  end
end