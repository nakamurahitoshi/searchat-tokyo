class CreateUserMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :user_messages do |t|
      t.references :user, foreign_key: true
      t.references :message, foreign_key: true
      t.boolean :is_gave, default: false, null: false
      t.timestamps
    end
  end
end
