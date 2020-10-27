class Conversation < ApplicationRecord
  include Conversable

  enum status: {
    open: 'open',
    assigned: 'assigned',
    closed: 'closed',
    archived: 'archived'
  }

  has_many :messages
  belongs_to :user, optional: true

  def send_message!(**attr)
    messages.create!(to: attr[:to], body: attr[:body], platform: self.platform, message_type: :outbound)
  end
end
