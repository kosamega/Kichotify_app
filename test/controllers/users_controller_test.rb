require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @admin = users(:user1)
    @not_admin = users(:user2)
    @kitchonkun = users(:kitchonkun)
  end

  test 'adminかkitchonkunだけusers newにアクセス出来る' do
    log_in_as(@not_admin)
    get new_user_path
    assert_redirected_to root_path
    delete sessions_path
    log_in_as(@admin)
    get new_user_path
    assert_response :success
    delete sessions_path
    log_in_as(@kitchonkun)
    get new_user_path
    assert_response :success
  end

  test 'adminかkitchonkunだけusersを作成できる' do
    log_in_as(@not_admin)
    assert_no_difference 'User.count' do
      post users_path, params: { user: { name: 'fail',
                                         password: 'password',
                                         password_confirmation: 'password' } }
    end
    assert_redirected_to root_path
    log_in_as(@admin)
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name: 'new_user1',
                                         password: 'password',
                                         password_confirmation: 'password' } }
    end
    follow_redirect!
    assert_template 'users/show'
    delete sessions_path
    log_in_as(@kitchonkun)
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name: 'new_user2',
                                         password: 'password',
                                         password_confirmation: 'password' } }
    end
    follow_redirect!
    assert_template 'users/show'
  end

  test '無効なユーザー登録は失敗する' do
    log_in_as(@admin)
    get new_user_path
    assert_no_difference 'User.count' do
      post users_path, params: { user: { name: '',
                                         password: 'foo',
                                         password_confirmation: 'bar' } }
    end
    assert_template 'users/new'
  end

  test 'userを更新できる' do
    log_in_as(@not_admin)
    get edit_user_path(@not_admin)
    assert_template 'users/edit'
    name = 'updated_not_admin'
    patch user_path(@not_admin), params: { user: { name:, password: '', password_confirmation: '' } }
    assert_not flash.empty?
    assert_redirected_to @not_admin
    @not_admin.reload
    assert_equal name, @not_admin.name
  end

  test 'エディターモードのオンオフができる' do
    log_in_as(@not_admin)
    assert_not @not_admin.editor?
    patch user_path(@not_admin), params: { user: { editor: true } }
    @not_admin.reload
    assert @not_admin.editor?
  end
end
