set :application, 'mise'
set :repo_url, 'https://github.com/sul-dlss/mise.git'
set :user, 'mise'

set :branch, 'main' if ENV['DEPLOY']
ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call unless ENV['DEPLOY']

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, "/var/www/my_app_name"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, %w(config/database.yml config/honeybadger.yml config/newrelic.yml config/settings/production.yml)

# Default value for linked_dirs is []
set :linked_dirs, %w(config/settings log node_modules tmp/pids tmp/cache tmp/sockets vendor/bundle public/packs public/system storage)

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
# set :keep_releases, 5

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure

# update shared_configs before restarting app
# before 'deploy:restart', 'shared_configs:update'

before "deploy:assets:precompile", "deploy:yarn_install"

namespace :deploy do
  desc 'Run rake yarn:install'
  task :yarn_install do
    on roles(:web) do
      within release_path do
        execute("cd #{release_path} && yarn install")
      end
    end
  end

  after :restart, :restart_sidekiq do
    on roles(:background) do
      sudo :systemctl, "restart", "sidekiq-*", raise_on_non_zero_exit: false
    end
  end
end
