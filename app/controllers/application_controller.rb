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

    # マイクロポストの検索
    def search_microposts(keywords, educational_material=false)
      where_command = ""
      keywords.each do |keyword|
        where_command += where_command.empty? ? "(T.content LIKE \'%#{keyword}%\' OR T.tag_names LIKE \'%#{keyword}%\')" : " AND (T.content LIKE \'%#{keyword}%\' OR T.tag_names LIKE \'%#{keyword}%\')"
      end
      
      filter_educational_material_command = educational_material ? "AND (T.`educational_material` = true)" : ""

      sql = "SELECT T.*
        FROM
          (SELECT
          `microposts`.*, GROUP_CONCAT(`tags`.name) AS tag_names
          FROM `microposts` JOIN `micropost_tags` ON `microposts`.id = `micropost_tags`.micropost_id JOIN `tags` ON `micropost_tags`.tag_id = `tags`.id
          GROUP BY `microposts`.id
          ) AS T
        WHERE (#{where_command} AND (T.`publishing` = 'public' OR T.`user_id` = '#{current_user.id}') #{filter_educational_material_command})
        ORDER BY T.`created_at` DESC;"

      a = ActiveRecord::Base.connection.select_all(sql).to_a
      Micropost.where(id: a.map{|val| val["id"]})
    end
end
