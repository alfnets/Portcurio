# frozen_string_literal: true

Kaminari.configure do |config|
  # config.page_method_name = :per_page_kaminari
  # config.default_per_page = 25
  config.default_per_page = 10
  # config.max_per_page = nil
  # config.window = 4
  config.window = 1
  # config.outer_window = 0
  # config.left = 0
  # config.right = 0
  config.right = 1
  # config.page_method_name = :page
  # config.param_name = :page
  # config.max_pages = nil
  # config.params_on_first_page = false
end
