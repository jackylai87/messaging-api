class Message < ApplicationRecord
  include Conversable

  enum message_type: {
    inbound: 'inbound',
    outbound: 'outbound'
  }

  belongs_to :conversation
  validate :only_same_platform, :reply_to_same_platform
  before_validation :set_platform, :assign_to_coversation, :set_outbound_from, on: :create
  before_create :send_to_twilio, if: :outbound?

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
    
    participant = Participant.find_or_create_by(contact: self.from)
    self.conversation_id = participant.conversation.id
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
    return unless Rails.env.production?
    request = {
      from: self.from,
      to: self.to,
      body: self.body
    }

    if !self.sms?
      # Send attachment
    end

    response = TWILIO_CLIENT.messages.create(request)

    twilio_response = outbound_twilio_response(response)
    self.twilio_response = twilio_response
  end

  def outbound_twilio_response(response)
    {
      from: response.from,
      to: response.to,
      body: response.body,
      direction: response.direction,
      error_message: response.error_message,
      uri: response.uri,
      account_sid: response.account_sid,
      num_media: response.num_media,
      messaging_service_sid: response.messaging_service_sid,
      sid: response.sid,
      date_created: response.date_created,
      error_code: response.error_code,
      api_version: response.api_version,
      subresource_uris: response.subresource_uris
    }
  end
end
