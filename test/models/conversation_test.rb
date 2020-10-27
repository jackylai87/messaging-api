require 'test_helper'

class ConversationTest < ActiveSupport::TestCase
  setup do
    @messenger = Message.new(
      to: 'messenger:102542248309018',
      from: 'messenger:4465012966906978',
      body: 'Hello There'
    )

    @whatsapp = Message.new(
      to: 'whatsapp:+60145586061',
      from: 'whatsapp:+60145586061',
      body: 'Hello There'
    )

    @sms = Message.new(
      to: '+60145586061',
      from: '+60145586061',
      body: 'Hello There'
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
end
