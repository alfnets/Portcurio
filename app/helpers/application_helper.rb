module ApplicationHelper
  require 'open-uri'

  # ページごとの完全なタイトルを返します。
  def full_title(page_title = '')
    # base_title = "Ruby on Rails Tutorial Sample App"
    if page_title.empty?
      site_name
    else
      page_title + " | " + site_name
    end
  end
  
  # サイト名を返す
  def site_name
    return "#{ENV['R_PREFIX'].capitalize} 教材SNS"
  end

  # ドメイン名を返す
  def domain_name
    return ENV.fetch('DOMAIN_NAME', nil)
  end
  
  # OGPの情報を取得
  def og_get(url)
    begin
      Rails.cache.fetch(url, expires_in: 1.day) do
        redirect_url = Net::HTTP.get_response(URI.parse(url))['location'] # リダイレクト先検出
        if redirect_url.nil?
          source = URI.open(url, 'User-Agent' => 'bot', &:read) # リダイレクト先がなかったら通常のURL
        else
          source = URI.open(redirect_url, 'User-Agent' => 'bot', &:read) # リダイレクト先があったらリダイレクト先のURL
        end
        OpenGraph.new(source)
      end
    rescue
      OpenGraph.new(url)
    end
  end
  
end
