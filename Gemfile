# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails', branch: 'main'
gem 'rails', '~> 7.0'

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem 'sprockets-rails'

# Use sqlite3 as the database for Active Record
gem 'sqlite3', '~> 1.4'

gem 'pg'

# Use Puma as the app server
gem 'puma', '~> 5.0'
# Use SCSS for stylesheets
gem 'sass-rails', '>= 6'

gem 'shakapacker', '~> 6.4'

# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
gem 'image_processing', '~> 1.2'

gem 'react-rails'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.4', require: false

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem 'debug', platforms: %i[mri mingw x64_mingw]

  gem 'rubocop', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 4.1.0'
  # Display performance information such as SQL time and flame graphs for each request in your browser.
  # Can be configured to work on production as well see: https://github.com/MiniProfiler/rack-mini-profiler/blob/master/README.md
  gem 'rack-mini-profiler', '~> 2.0'

  gem 'listen', '~> 3.3'
end

group :deployment do
  gem 'capistrano', '~> 3.0'
  gem 'capistrano-bundler'
  gem 'capistrano-passenger'
  gem 'capistrano-rails'
  gem 'capistrano-rvm'
  gem 'capistrano-shared_configs'
  gem 'dlss-capistrano'
end

group :development, :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 3.26'
  gem 'selenium-webdriver'
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers'

  gem 'factory_bot_rails'
  gem 'rspec-rails'
end

gem 'honeybadger'
gem 'newrelic_rpm'
gem 'okcomputer'

gem 'acts_as_favoritor'
gem 'ancestry'
gem 'cancancan'
gem 'config'
gem 'devise', '~> 4.8'
gem 'devise_invitable'
gem 'friendly_id'
gem 'jwt'
gem 'omniauth'
gem 'omniauth-rails_csrf_protection'
gem 'omniauth-shibboleth'
gem 'paper_trail'
gem 'redis', '~> 4.5.1' # 4.6.0 spews deprecation warnings out of sidekiq
gem 'rolify'
gem 'tophat'

gem 'annotot', github: 'mejackreed/annotot'

gem 'puppeteer-ruby'

source 'https://gems.contribsys.com/' do
  gem 'sidekiq-pro', '< 7', group: :production # Remain on v5 until Redis is updated to v7 on VMs
end

gem 'sidekiq', '< 7' # Remain on v6 until Redis is updated to v7 on VMs

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

# Setting version of rack-protection to < 3 due to incompatibility
# between omniauth and rack-protection 3
# https://github.com/sinatra/sinatra/issues/1817
gem 'rack-protection', '< 3'
