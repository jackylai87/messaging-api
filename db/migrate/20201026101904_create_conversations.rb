class CreateConversations < ActiveRecord::Migration[6.0]
  def change
    create_table :conversations, id: :uuid do |t|
      t.string :status
      t.string :platform

      t.timestamps
    end
  end
end
