class CreateParticipants < ActiveRecord::Migration[6.0]
  def change
    create_table :participants, id: :uuid do |t|
      t.string :contact, null: false

      t.timestamps
    end

    add_index :participants, :contact, unique: true
    add_reference :conversations, :participant, type: :uuid, foreign_key: true, index: {unique: true}
    change_column_null :conversations, :participant_id, false
  end
end
