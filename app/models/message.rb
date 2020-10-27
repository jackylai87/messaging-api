class Message < ApplicationRecord
  include Conversable

  enum message_type: {
    inbound: 'inbound',
    outbound: 'outbound'
  }

  belongs_to :conversation
  validate :only_same_platform, :reply_to_same_platform
  before_validation :set_platform, :assign_to_coversation, :set_outbound_from, on: :create
  before_create :send_to_twilio, if: :inbound?

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
    return if self.outbound?
    self.platform = extract_platform(self.to)
  end

  def assign_to_coversation
    return if self.outbound?
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
        "Receiver platform (#{self.to}) is different from sender platform (#{self.from})"
      )
    end
  end

  def set_outbound_from
    return if self.inbound?
    self.from = Rails.application.credentials.twilio[self.platform.to_sym]
  end

  def send_to_twilio
    return if Rails.env.development?
    request = {
      from: self.from,
      to: self.to,
      body: self.body
    }

    if !self.sms?
      # Send attachment
    end

    TWILIO_CLIENT.messages.create(request)
  end
end
