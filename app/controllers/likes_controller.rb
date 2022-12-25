class LikesController < ApplicationController
  before_action :logged_in_user, :not_kitchonkun
  before_action :set_variables
  include MusicsHelper

  def index
    @likes = current_user.likes
    @musics = @likes.map(&:music)
    @playlists = current_user.playlists
    @like_index = true
    @infos = []
    set_infos(@musics)
    gon.infos_j = @infos
  end

  def create
    @like = current_user.likes.build(music_id: params[:music_id])
    @like.save
    @number = params[:number]
    respond_to do |format|
      format.html { redirect_back_or '/' }
      format.js
    end
  end

  def destroy
    @like = Like.find_by(id: params[:like_id])
    @music = @like.music
    @number = params[:number]
    return unless @like.user == current_user

    @unliked_music = @like.music
    @like.destroy
    @like_index = params[:like_index]
    respond_to do |format|
      format.html { redirect_back_or '/' }
      format.js
    end
  end

  private

  def set_variables
    @track_id = params[:number]
    @like_id = "like#{params[:number]}"
  end
end
