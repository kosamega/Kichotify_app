class ApplicationController < ActionController::Base
    before_action :store_location
    include SessionsHelper
    # 最後にgetリクエストを送ったURLを覚えておく
    def store_location
        session[:forwarding_url] = request.original_url if request.get?
    end

    # ユーザーのログインを確認する
    def logged_in_user
        unless logged_in?
            store_location
            flash[:danger] = "ログインしてください"
            redirect_to "/login"            
        end
    end
end
