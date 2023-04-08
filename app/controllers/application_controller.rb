class ApplicationController < ActionController::Base
  include SessionsHelper
  before_action :set_noindex
  before_action :get_time_line
    
  private

    def set_noindex
      @noindex = !whitelisted?(request.path_info)
    end

    def whitelisted?(path_info)
      whitelist = ['/', '/links', '/help', '/login', '/signup']
      whitelist.include?(path_info)
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

    # マイクロポストの検索
    def search_microposts(keywords, educational_material=true, user=nil)
      where_command = ""
      keywords.each do |keyword|
        where_command += where_command.empty? ? "(T.content LIKE \'%#{keyword}%\' OR T.tag_names LIKE \'%#{keyword}%\')" : " AND (T.content LIKE \'%#{keyword}%\' OR T.tag_names LIKE \'%#{keyword}%\')"
      end
      
      if educational_material.nil?
        filter_educational_material_command = ""
      else
        filter_educational_material_command = educational_material ? "AND (T.`educational_material` = true)" : "AND (T.`educational_material` = false)"
      end

      if logged_in?
        sql = "SELECT T.*
          FROM
            (SELECT
            `microposts`.*, GROUP_CONCAT(`tags`.name) AS tag_names
            FROM `microposts` JOIN `micropost_tags` ON `microposts`.id = `micropost_tags`.micropost_id JOIN `tags` ON `micropost_tags`.tag_id = `tags`.id
            GROUP BY `microposts`.id
            ) AS T
          WHERE (#{where_command} AND (T.`publishing` = 'public' OR T.`user_id` = '#{current_user.id}') #{filter_educational_material_command})
          ORDER BY T.`created_at` DESC;"
      else
        sql = "SELECT T.*
        FROM
          (SELECT
          `microposts`.*, GROUP_CONCAT(`tags`.name) AS tag_names
          FROM `microposts` JOIN `micropost_tags` ON `microposts`.id = `micropost_tags`.micropost_id JOIN `tags` ON `micropost_tags`.tag_id = `tags`.id
          GROUP BY `microposts`.id
          ) AS T
        WHERE (#{where_command} AND (T.`publishing` = 'public') #{filter_educational_material_command})
        ORDER BY T.`created_at` DESC;"
      end

      a = ActiveRecord::Base.connection.select_all(sql).to_a
      if user
        user.microposts.where(id: a.map{|val| val["id"]})
      else
        Micropost.where(id: a.map{|val| val["id"]})
      end
    end

    # ログインユーザーのタイムラインを取得
    def get_time_line
      @time_line_items = current_user.time_line.page(params[:page]) if logged_in?
    end
end
