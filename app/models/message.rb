class Message < ApplicationRecord
  include Conversable

  belongs_to :conversation
  before_validation :set_platform, :assign_to_coversation, on: :create

  private
  def set_platform
    case self.to
    when /\Amessenger/
      self.platform = 'messenger'
    when /\Awhatsapp/
      self.platform = 'whatsapp'
    when /\A+\D+/
      self.platform = 'sms'
    end
  end

  def assign_to_coversation
    message = self.class.find_by(from: self.from)

    if message
      self.conversation_id = message.conversation_id
    else
      self.conversation = Conversation.create!(platform: self.platform)
    end
  end
end
