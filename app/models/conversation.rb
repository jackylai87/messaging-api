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
  validate :assigned_if_have_user

  def send_message!(**attr)
    messages.create!(to: attr[:to], body: attr[:body], platform: self.platform, message_type: :outbound)
  end

  def assign_to(user_id)
    update!(user_id: user_id, status: :assigned)
  end

  def unassign
    update!(user_id: nil, status: :open)
  end

  private
  def assigned_if_have_user
    raise ConversationError::FailedToAssign.new 'Must be assigned to a user' if user_id.nil? && assigned?
  end
end
