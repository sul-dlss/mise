# frozen_string_literal: true

# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative 'config/application'

begin
  require 'rubocop/rake_task'
  RuboCop::RakeTask.new(:rubocop) do |task|
    task.fail_on_error = true
  end
rescue LoadError
  # this rescue block is here for deployment to production, where
  # certain dependencies are not expected, and that is OK
  warn 'WARNING: Rubocop was not found and could not be required.'
end

task default: %i[rubocop environment spec]

Rails.application.load_tasks
