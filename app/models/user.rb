class User < ApplicationRecord
  has_many :conversations
  has_secure_password
end
