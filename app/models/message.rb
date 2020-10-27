class Message < ApplicationRecord
  enum platform: {
    sms: 'sms',
    messenger: 'messenger',
    whatsapp: 'whatsapp'
  }
end
