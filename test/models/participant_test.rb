require 'test_helper'

class ParticipantTest < ActiveSupport::TestCase
  test "has one conversation" do
    assert participants(:participant_messenger).respond_to? 'create_conversation'

    assert_raises(ActiveRecord::RecordNotUnique) do
      conversation = conversations(:one)
      Conversation.create(platform: 'sms', participant: conversation.participant)
    end
  end

  test "automatically create conversation" do
    participant = Participant.create(contact: '+123123123')

    assert_not_nil participant.conversation
  end
end
