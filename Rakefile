# frozen_string_literal: true

require 'bundler/gem_tasks'

require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

require 'rubocop/rake_task'

RuboCop::RakeTask.new

task default: [:spec, :rubocop, :check_config_default_yml]

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

desc 'Check config/default.yml'
task check_config_default_yml: :yard_for_generate_documentation do
  require 'yard'

  current_config = YAML.unsafe_load_file('config/default.yml')
  YARD::Registry.load!

  code_names = YARD::Registry.all(:class).filter_map do |doc|
    doc_slash = doc.to_s.delete_prefix('RuboCop::Cop::').gsub('::', '/')
    next unless doc_slash.count('/') == 2

    doc_slash
  end.to_set
  config_names = current_config.keys.filter_map do |key|
    next unless key.count('/') == 2

    key
  end.to_set

  code_names.each do |doc_slash|
    unless config_names.include?(doc_slash)
      raise "Coded cop: `#{doc_slash}` is not configured."
    end
  end
  config_names.each do |key|
    unless code_names.include?(key)
      raise "Configured cop: `#{key}` is not exists."
    end
  end

  puts 'config/default.yml is OK'
end
