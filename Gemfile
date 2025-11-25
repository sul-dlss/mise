# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails', branch: 'main'
gem 'rails', '~> 7.2'

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem 'sprockets-rails'

# Use sqlite3 as the database for Active Record
gem 'sqlite3', '~> 1.4'

gem 'pg'

# Use Puma as the app server
gem 'puma', '~> 6.0'

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
  gem 'rubocop-capybara', require: false
  gem 'rubocop-factory_bot', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
  gem 'rubocop-rspec_rails', require: false
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 3.26'
  gem 'selenium-webdriver'

  gem 'factory_bot_rails', '~> 6.4'
  gem 'rspec-rails'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 4.1.0'
  # Display performance information such as SQL time and flame graphs for each request in your browser.
  # Can be configured to work on production as well see: https://github.com/MiniProfiler/rack-mini-profiler/blob/master/README.md
  gem 'rack-mini-profiler', '~> 2.0'
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
gem 'redis', '~> 5.0'
gem 'rolify'
gem 'tophat'

gem 'annotot', github: 'PenguinParadigm/annotot', branch: 'main'

gem 'puppeteer-ruby'

source 'https://gems.contribsys.com/' do
  gem 'sidekiq-pro', group: :production
end

gem 'sidekiq', '~> 8.0'

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

# Setting version of rack-protection to < 3 due to incompatibility
# between omniauth and rack-protection 3
# https://github.com/sinatra/sinatra/issues/1817
gem 'rack-protection', '< 3'

gem 'cssbundling-rails', '~> 1.1'

gem 'connection_pool', '~> 2.5' # pinned until fix for https://github.com/rails/rails/issues/56291 is released
