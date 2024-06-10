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
      argv: %w(check --jobs 2)
    ).run
  end
end

task default: [:spec, :rubocop, 'steep:check']


require 'yard'

YARD::Rake::YardocTask.new(:yard_for_generate_documentation) do |task|
  task.files = ['lib/rubocop/cop/**/*.rb']
  task.options = ['--no-output']
end

task update_cops_documentation: :yard_for_generate_documentation do
  require 'rubocop-on-rbs'
  require 'rubocop/cops_documentation_generator'
  RuboCop::RBS::Inject.defaults!

  departments = [
    'RBS/Layout',
    'RBS/Lint',
    'RBS/Style'
  ]

  CopsDocumentationGenerator.new(departments: departments).call
end
