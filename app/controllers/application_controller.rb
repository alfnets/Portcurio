class ApplicationController < ActionController::Base
  include SessionsHelper
  
  private
  
    # ログイン済みユーザーかどうか確認
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end
    
    # lineクライアント
    def client
      @client ||= Line::Bot::Client.new { |config|
        config.channel_id = ENV.fetch("LINE_CHANNEL_ID", nil)
        config.channel_secret = ENV.fetch("LINE_CHANNEL_SECRET", nil)
        config.channel_token = ENV.fetch("LINE_CHANNEL_TOKEN", nil)
      }
    end
end
