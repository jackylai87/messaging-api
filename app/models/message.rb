class Message < ApplicationRecord
  include Conversable

  belongs_to :conversation
  validate :only_same_platform, :reply_to_same_platform
  before_validation :set_platform, :assign_to_coversation, on: :create

  private
  def extract_platform(contact)
    case contact
    when /\Amessenger/
      'messenger'
    when /\Awhatsapp/
      'whatsapp'
    when /\A+\D+/
      'sms'
    end
  end

  def set_platform
    return unless self.platform.nil?
    self.platform = extract_platform(self.to)
  end

  def assign_to_coversation
    return unless self.conversation_id.nil?
    message = self.class.find_by(from: self.from)

    if message
      self.conversation_id = message.conversation_id
    else
      self.conversation = Conversation.create!(platform: self.platform)
    end
  end

  def only_same_platform
    conversation = self.conversation

    unless conversation.platform == self.platform
      errors.add(
        :base,
        "This conversation platform (#{self.platform}) is different to assigned conversation platform (#{conversation.platform})"
      )
    end
  end

  def reply_to_same_platform
    unless extract_platform(self.to) == extract_platform(self.from)
      errors.add(
        :base,
        "Receiver platform is different from sender platform"
      )
    end
  end
end
