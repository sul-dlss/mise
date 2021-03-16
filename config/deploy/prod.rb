set :home_directory, "/opt/app/#{fetch(:user)}"
set :deploy_to, "#{fetch(:home_directory)}/#{fetch(:application)}"

server 'mise-prod-a.stanford.edu', user: 'mise', roles: %w[web db app]
server 'mise-prod-b.stanford.edu', user: 'mise', roles: %w[web db app]

Capistrano::OneTimeKey.generate_one_time_key!

set :bundle_without, %w(deployment development test).join(' ')

set :rails_env, 'production'
