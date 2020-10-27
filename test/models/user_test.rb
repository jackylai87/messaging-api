require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "must have email" do
    assert_raises(ActiveRecord::NotNullViolation) {
      user = users(:one)
      user.email = nil
      user.save!
    }
  end

  test "has many conversations" do
    assert users(:one).respond_to? "conversations"
  end
end
