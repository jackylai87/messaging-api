class Conversation < ApplicationRecord
  include Conversable

  enum status: {
    open: 'open',
    assigned: 'assigned',
    closed: 'closed',
    archived: 'archived'
  }

  has_many :messages
end
