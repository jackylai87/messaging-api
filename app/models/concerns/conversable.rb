module Conversable
  extend ActiveSupport::Concern

  included do
    enum platform: {
      sms: 'sms',
      messenger: 'messenger',
      whatsapp: 'whatsapp'
    }
  end
end