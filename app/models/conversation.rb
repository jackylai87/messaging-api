class Conversation < ApplicationRecord
  include Conversable

  enum status: {
    open: 'open',
    assigned: 'assigned',
    closed: 'closed',
    archived: 'archived'
  }

  has_many :messages

  def send_message!(**attr)
    messages.create!(from: attr[:from], to: attr[:to], body: attr[:body], platform: self.platform)
  end
end
