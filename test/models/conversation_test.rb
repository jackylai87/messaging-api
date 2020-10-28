require 'test_helper'

class ConversationTest < ActiveSupport::TestCase
  setup do
    @messenger = Message.new(
      to: 'messenger:102542248309018',
      from: 'messenger:4465012966906978',
      body: 'Hello There',
      message_type: :inbound
    )

    @whatsapp = Message.new(
      to: 'whatsapp:+60145586061',
      from: 'whatsapp:+60145586061',
      body: 'Hello There',
      message_type: :inbound
    )

    @sms = Message.new(
      to: '+60145586061',
      from: '+60145586061',
      body: 'Hello There',
      message_type: :inbound
    )
  end
  
  test "should default to open" do
    assert Conversation.create!(platform: 'sms')
  end

  test "should follow messages platform" do
    @messenger.save!
    @sms.save!
    @whatsapp.save!
    assert @messenger.platform == @messenger.conversation.platform
    assert @sms.platform == @sms.conversation.platform
    assert @whatsapp.platform == @whatsapp.conversation.platform
  end

  test 'should reply to same conversation' do
    conversation = conversations(:one)
    message = conversation.send_message!(to: '+60145586061', body: 'Hi', message_type: :outbound)
    assert conversation.id == message.conversation_id
  end

  test "outbound message set from column autmatically" do
    conversation = Conversation.create(platform: 'whatsapp')
    conversation.send_message!(to: 'whatsapp:+60145586061', body: 'Sup')

    assert conversation.persisted?
  end

  test "belongs to user" do
    assert conversations(:one).respond_to? "user"
  end

  test "should be able to assign conversation" do
    assert_nothing_raised do 
      conversations(:unassigned).assign_to(users(:one).id)
    end
  end

  test "should be able to unassign conversation" do
    assert_nothing_raised do
      conversations(:one).unassign
    end
  end

  test "should can only in assign status if have user" do
    assert_raises(ConversationError::FailedToAssign){
      conversations(:unassigned).assigned!
    }
  end
end
