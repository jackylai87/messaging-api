module Conversable
  extend ActiveSupport::Concern

  include do
    enum platform: {
      sms: 'sms',
      messenger: 'messenger',
      whatsapp: 'whatsapp'
    }
  end
end