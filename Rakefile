# frozen_string_literal: true

require 'bundler/gem_tasks'

require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

require 'rubocop/rake_task'

RuboCop::RakeTask.new

namespace :steep do
  task :check do
    require 'steep'
    require 'steep/cli'
    Steep::CLI.new(
      stdin: $stdin,
      stdout: $stdout,
      stderr: $stderr,
      argv: %w(check)
    ).run
  end
end

task default: [:spec, :rubocop, 'steep:check']
