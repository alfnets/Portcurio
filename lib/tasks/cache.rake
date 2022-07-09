namespace :cache do
  desc "Clear cache"
  task :clear => :environment do
    Rails.cache.clear
    puts "Clear cache at #{Time.now}"
  end
end