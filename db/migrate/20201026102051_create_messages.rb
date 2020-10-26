class CreateMessages < ActiveRecord::Migration[6.0]
  def change
    create_table :messages, id: :uuid do |t|
      t.string :to, null: false
      t.string :from, null: false
      t.text :body, null: false
      t.jsonb :twilio_response, null: false, default: {}

      t.timestamps
    end
  end
end
