require 'test_helper'

class MessagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @twilio_request = {
      "SmsMessageSid": "SM801895646fa79bf6e914d6e9a0aeb0ad",
      "NumMedia": "0",
      "SmsSid": "SM801895646fa79bf6e914d6e9a0aeb0ad",
      "SmsStatus": "received",
      "Body": "Hi",
      "To": "messenger:102542248309018",
      "NumSegments": "1",
      "MessageSid": "SM801895646fa79bf6e914d6e9a0aeb0ad",
      "AccountSid": "ACd22dd2a91e81d7797c3d004e14e91424",
      "From": "messenger:4465012966906978",
      "ApiVersion": "2010-04-01"
    }
  end
  
  test "should return success" do
    post twilio_messages_url, params: @twilio_request
    assert_response :success
  end

  test "should return error" do
    post twilio_messages_url, params: {}
    assert_response :bad_request
  end
end
