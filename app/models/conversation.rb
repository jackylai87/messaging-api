class Conversation < ApplicationRecord
  include Conversable

  enum status: {
    open: 'open',
    assigned: 'assigned',
    closed: 'closed'
  }

  has_many :messages
end
