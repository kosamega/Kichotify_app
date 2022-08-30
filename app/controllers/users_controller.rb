class UsersController < ApplicationController
  before_action :logged_in_user
  before_action :not_kitchonkun, only: [:edit, :update]
  

  def show
    @user = User.find_by(id: params[:id])
    @playlists = @user.playlists
  end

  def edit
  end

  def update
    if current_user.update(user_params)
      redirect_to "/users/#{current_user.id}"
    else
      flash[:danger] = "すでに存在する名前です"
      redirect_to edit_user_path(current_user)
    end
  end

  def index
    @users = User.all
  end

  private
    def user_params
      params.require(:user).permit(:name, :bio)
    end

end
