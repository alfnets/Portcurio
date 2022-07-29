class ApplicationController < ActionController::Base
  include SessionsHelper

  before_action :set_search_microposts
  
  private
  
    def set_search_microposts
      if params[:q]
        @search_microposts = Micropost.ransack(content_cont_all: params[:q][:content_cont_all].gsub("　"," ").split)
        @result_search_microposts = @search_microposts.result
      else
        @search_microposts = Micropost.ransack(params[:q])
      end
    end

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
