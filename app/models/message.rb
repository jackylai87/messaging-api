class Message < ApplicationRecord
  include Conversable

  belongs_to :conversation
end
