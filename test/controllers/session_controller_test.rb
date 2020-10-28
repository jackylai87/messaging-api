require 'test_helper'

class SessionControllerTest < ActionDispatch::IntegrationTest
  test "should login" do
    post login_path, params: {email: users(:one).email, password: 'asdf1234'}
    assert_response :created
    assert session[:user] == users(:one).id
  end

  test "should not login if wrong password" do
    post login_path, params: {email: users(:one).email, password: 'asdf'}
    assert_response :bad_request
    assert session[:user].nil?
  end

  test "should not login if wrong email" do
    post login_path, params: {email: 'asd@asd.com', password: 'asdf1234'}
    assert_response :bad_request
    assert session[:user].nil?
  end

  test "clear session" do
    delete logout_path
    assert_response :success
    assert session[:user].nil?
  end
end
