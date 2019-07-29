require 'test_helper'

class UserTest < ActiveSupport::TestCase
  
  test "user creation success" do
    user = User.new(name: "Test", email: "test@test.com", password: "password", password_confirmation: "password")
    assert user.save
  end

  test "no email" do
  	user = User.new(name: "Test", email: "test@test.com")
  	assert_not user.save
  end

  test "correct email format" do
    user = User.new(name: "Test", email: "bad email address", password: "password", password_confirmation: "password")
    assert_not user.save
  end

  test "no name" do
  	user = User.new(email: "test@test.com", password: "password", password_confirmation: "password")
  	assert_not user.save
  end


  test "email already exists" do
  	user = User.new(name: "Test", email: "a@a.com", password: "password", password_confirmation: "password")
  	assert_not user.save
  end

end
