begin
  require 'sidekiq-pro'
  Sidekiq::Client.reliable_push! unless Rails.env.test?
rescue LoadError => e
  $stderr.puts "Unable to load sidekiq-pro: #{e}" if Rails.application.config.active_job.queue_adapter == :sidekiq
end

Sidekiq.configure_server do |config|
  if defined? Sidekiq::Pro
    config.super_fetch!
    config.reliable_scheduler!
  end
  config.logger.level = Object.const_get(Settings.sidekiq.logger_level)
end

Sidekiq.configure_server do |config|
  config.redis = Settings.sidekiq.redis.to_h if Settings.sidekiq.redis
end

Sidekiq.configure_client do |config|
  config.redis = Settings.sidekiq.redis.to_h if Settings.sidekiq.redis
end
