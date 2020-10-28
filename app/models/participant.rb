class Participant < ApplicationRecord
  has_one :conversation
  after_create :create_empty_conversation

  private
  def create_empty_conversation
    case contact
    when /\Amessenger/
      platform = 'messenger'
    when /\Awhatsapp/
      platform = 'whatsapp'
    when /\A+\D+/
      platform = 'sms'
    end

    create_conversation(platform: platform)
  end
end
