class AlbumsController < ApplicationController
    before_action :logged_in_user
    def show
        @album = Album.find_by(id: params[:id])
        @musics = @album.musics
    end

end
