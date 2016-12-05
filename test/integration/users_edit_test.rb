require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:test)
  end

  test 'unsuccessful edit' do
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: { user: { name: '', email: 'a@b', password: 'abc', password_confirmation: 'def' } }
    assert_template 'users/edit'
    assert_select 'div .alert', text: 'The form contains 4 errors.'
  end

  test 'successful edit' do
    get edit_user_path(@user)
    assert_template 'users/edit'
    name = 'Test user new'
    email = 'test@example.com'
    patch user_path(@user), params: { user: {name: name, email: email, password: '', password_confirmation: '' }}
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name, @user.name
    assert_equal email, @user.email
  end
end
