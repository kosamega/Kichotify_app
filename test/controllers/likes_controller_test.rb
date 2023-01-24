require 'test_helper'

class LikesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:user1)
    @music = musics(:music2)
  end

  test 'ログインしないとlikeを作成出来なく、するとできる' do
    post likes_path, params: { music_id: @music.id, user_id: @user.id }
    assert_not flash.empty?
    assert_redirected_to new_sessions_path
    log_in_as(@user)
    assert_difference 'Like.count', 1 do
      post likes_path, params: { music_id: @music.id, user_id: @user.id }
    end
  end

  test 'ログインしないとlikeを削除できなく、するとできる' do
    log_in_as(@user)
    post likes_path, params: { music_id: @music.id, user_id: @user.id }
    like = Like.find_by(music_id: @music.id, user_id: @user.id)
    assert_difference 'Like.count', -1 do
      delete like_path(like), params: { like_id: like.id }
    end
    delete sessions_path
    assert_not is_logged_in?
    delete like_path(like), params: { like_id: like.id }
    assert_not flash.empty?
    assert_redirected_to new_sessions_path
  end

  test 'ログインしないとlike一覧にアクセスできない' do
    get '/likes'
    assert_not flash.empty?
    assert_redirected_to new_sessions_path
  end
end
