require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:test)
    @admin_user = users(:admin)
  end

  test 'should get new' do
    get signup_path
    assert_response :success
  end

  test 'should redirect edit when not logged in' do
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test 'should redirect update when not logged in' do
    patch user_path(@user), params: { user: { name: @user.name, email: @user.email } }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test 'should redirect edit when logged in as wrong user' do
    log_in_as(@admin_user)
    get edit_user_path(@user)
    assert flash.empty?
    assert_redirected_to root_url
  end

  test 'should redirect update when logged in as wrong user' do
    log_in_as(@admin_user)
    patch user_path(@user), params: { user: { name: @user.name, email: @user.email } }
    assert flash.empty?
    assert_redirected_to root_url
  end

  test 'should redirect index when not logged in' do
    get users_path
    assert_redirected_to login_url
  end

  test 'should not allow admin attribute to be modified via web' do
    log_in_as @user
    assert_not @user.admin?
    patch user_path(@user), params: { user: { admin: true } }
    assert_not @user.reload.admin?
  end

end
