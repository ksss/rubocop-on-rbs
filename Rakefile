# frozen_string_literal: true

require 'bundler/gem_tasks'

require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

require 'rubocop/rake_task'

RuboCop::RakeTask.new

task default: [:spec]

require 'yard'
require 'rubocop-on-rbs'
require 'rubocop/cops_documentation_generator'

class CopsDocumentationGeneratorOnRBS < CopsDocumentationGenerator
  private

  def code_example(rbs_code)
    content = +"[source,rbs]\n----\n"
    content << rbs_code.text.gsub('@good', '# good').gsub('@bad', '# bad').strip
    content << "\n----\n"
    content
  end
end

YARD::Rake::YardocTask.new(:yard_for_generate_documentation) do |task|
  task.files = ['lib/rubocop/cop/**/*.rb']
  task.options = ['--no-output']
end

desc 'Update Cops Documentation'
task update_cops_documentation: :yard_for_generate_documentation do
  rm_rf('docs/')

  departments = [
    'RBS/Layout',
    'RBS/Lint',
    'RBS/Style'
  ]
  CopsDocumentationGeneratorOnRBS.new(departments: departments).call
end
