class CreateConversations < ActiveRecord::Migration[6.0]
  def change
    create_table :conversations, id: :uuid do |t|
      t.string :status, null: false, default: 'open'
      t.string :platform, null: false

      t.timestamps
    end
  end
end
