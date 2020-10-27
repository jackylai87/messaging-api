require 'test_helper'

class MessageTest < ActiveSupport::TestCase
  setup do
    @messenger = Message.new(
      to: 'messenger:102542248309018',
      from: 'messenger:4465012966906978',
      body: 'Hello There',
      message_type: 'inbound'
    )

    @whatsapp = Message.new(
      to: 'whatsapp:+60145586061',
      from: 'whatsapp:+60145586061',
      body: 'Hello There',
      message_type: 'inbound'
    )

    @sms = Message.new(
      to: '+60145586061',
      from: '+60145586061',
      body: 'Hello There',
      message_type: 'inbound'
    )
  end

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

  test "raise error if null message type column" do
    assert_raises(ActiveRecord::NotNullViolation) {
      message = messages(:message_one)
      message.message_type = nil
      message.save!
    }
  end

  test "twilio_response default to empty hash" do
    assert messages(:message_one).twilio_response == {}
  end

  test "should self set message platform" do
    [@sms, @messenger, @whatsapp].each{ |message| message.save! }
    assert @sms.sms?
    assert @messenger.messenger?
    assert @whatsapp.whatsapp?
  end

  test "should self assign to conversation" do
    @sms.save!
    assert_not @sms.conversation_id.nil?
  end

  test "should assign to existing conversation" do
    @sms.save!
    another_sms = Message.create(
      to: '+60145586061',
      from: '+60145586061',
      body: 'Hello please',
      message_type: :inbound
    )

    assert @sms.conversation_id == another_sms.conversation_id
  end

  test "can only add to conversation of same platform" do
    conversation = Conversation.create(platform: 'whatsapp')
    @sms.save!
    assert_raises(ActiveRecord::RecordInvalid) {
      @sms.update!(conversation: conversation)
    }
  end

  test "can only send to same platform" do
    assert_raises(ActiveRecord::RecordInvalid){
      Message.create!(
        to: 'whatsapp:+60145586061',
        from: '+60145586061',
        body: 'Hello There',
        message_type: :inbound
      )
    }
  end
end
