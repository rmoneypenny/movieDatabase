


require "application_system_test_case"

class UsersTest < ApplicationSystemTestCase


test "creating a user success" do
  visit new_user_path
 
  fill_in :name, with: "ABC"
  fill_in :email, with: "abc@def.com"
  fill_in :password, with: "test"
  fill_in :password_confirmation, with: "test"
  
  click_on "Create"
 
  assert_text "Account created!"
end

test "log in success" do

  user = User.create(name: "ABC", email: "abc@def.com", password: "test", password_confirmation: "test")

  visit root_path
  click_on "Log In"

  fill_in :email, with: "abc@def.com"
  fill_in :password, with: "test"
  
  click_on "Login"
 
  assert_text "Logged In"
end


end