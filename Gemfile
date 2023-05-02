source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails', branch: 'main'
gem 'rails', '7.0.4.3'
# Use mysql as the database for Active Record
gem 'mysql2'
# Use Puma as the app server
gem 'puma'
# Use SCSS for stylesheets
gem 'sass-rails'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
gem 'bcrypt'

# Use Active Storage variant
gem 'image_processing'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false

# add gems
gem 'aws-sdk-s3', require: false             
gem 'active_storage_validations'
gem 'faker' # いらないかも？
gem 'kaminari'
gem 'kaminari-bootstrap'
gem 'bootstrap-sass'
gem 'rinku'
gem 'ogp'   # いらないかも？
gem "opengraph_parser"
gem 'nokogiri'
gem 'ruby-oembed'
gem 'hirb'
gem 'hirb-unicode-steakknife'
gem 'line-bot-api'
gem "attr_encrypted"
gem 'mail-iso-2022-jp'  # いらないかも？
gem 'pry-rails'
gem 'whenever', require: false
gem 'rails-i18n'
gem "flat-ui-rails"
gem 'meta-tags'
gem 'ransack'
gem "font-awesome-sass"

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]

  gem 'rspec-rails'
  gem 'factory_bot_rails'

  gem 'rubocop', require: false
  gem "rubocop-performance", require: false
  gem "rubocop-rails", require: false
  gem "rubocop-rspec", require: false
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console'
  # Display performance information such as SQL time and flame graphs for each request in your browser.
  # Can be configured to work on production as well see: https://github.com/MiniProfiler/rack-mini-profiler/blob/master/README.md
  gem 'rack-mini-profiler'
  gem 'listen'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen'
  gem 'rails_real_favicon'
end

group :test do
  gem 'capybara'
  gem 'selenium-webdriver'
  gem 'webdrivers'
  gem 'rails-controller-testing'
  # gem 'minitest'
  # gem 'minitest-reporters'
  gem 'guard'
  # gem 'guard-minitest'
  gem 'guard-rspec', require: false
  
  gem 'launchy'
  gem 'shoulda-matchers'
  gem 'vcr'
  gem 'webmock'
end

group :production, :staging do
  gem 'sendgrid-actionmailer'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
