class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users, id: :uuid do |t|
      t.string :email, null: false
      t.string :display_name
      t.string :password_digest, null: false

      t.timestamps
    end

    add_index :users, :email, unique: true
    add_reference :conversations, :user, foreign_key: true, type: :uuid
  end
end
