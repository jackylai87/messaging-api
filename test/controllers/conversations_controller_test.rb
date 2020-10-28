require 'test_helper'

class ConversationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_in_as(users(:one).email, 'asdf1234')
  end

  test "can list all conversations" do
    assert_routing '/conversations', controller: 'conversations', action: 'index'
    get conversations_url
    assert_response :ok
  end

  test "visit conversation" do
    assert_routing(
      '/conversations/4417b529-e19b-432e-9c11-dea9645fab00', 
      controller: 'conversations', 
      action: 'show', 
      id: '4417b529-e19b-432e-9c11-dea9645fab00'
    )
    
    get conversation_url(conversations(:one).id)
    assert_response :ok
  end

  test "respond to not_found" do
    get conversation_url('123')
    assert_response :not_found
  end

  test "able to update conversation status" do
    assert_routing(
      {
        path: '/conversations/4417b529-e19b-432e-9c11-dea9645fab00',
        method: :patch
      }, 
      controller: 'conversations', 
      action: 'update', 
      id: '4417b529-e19b-432e-9c11-dea9645fab00'
    )

    patch conversation_url(conversations(:one).id), params: {conversation: {status: 'assigned'}}
    assert_response :ok
  end

  test "fail to update conversation should return bad request status" do
    patch conversation_url(conversations(:one).id), params: {conversation: {status: '123'}}
    assert_response :bad_request
  end
end
