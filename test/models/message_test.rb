require 'test_helper'

class MessageTest < ActiveSupport::TestCase
  test "message have id uuid type" do
    assert = Message.columns.find{|col| col.name == 'id'}.sql_type == 'uuid'
  end

  test "raise error if null to column" do
    assert_raises(ActiveRecord::NotNullViolation) {
      message = messages(:message_one)
      message.to = nil
      message.save!
    }
  end

  test "raise error if null from column" do
    assert_raises(ActiveRecord::NotNullViolation) {
      message = messages(:message_one)
      message.from = nil
      message.save!
    }
  end

  test "raise error if null body column" do
    assert_raises(ActiveRecord::NotNullViolation) {
      message = messages(:message_one)
      message.body = nil
      message.save!
    }
  end

  test "raise error if null twilio response column" do
    assert_raises(ActiveRecord::NotNullViolation) {
      message = messages(:message_one)
      message.twilio_response = nil
      message.save!
    }
  end

  test "twilio_response default to empty hash" do
    assert messages(:message_one).twilio_response == {}
  end
end
