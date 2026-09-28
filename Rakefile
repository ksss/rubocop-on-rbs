# frozen_string_literal: true

require 'bundler/gem_tasks'

require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

require 'rubocop/rake_task'

RuboCop::RakeTask.new

task default: [:spec, :check_config_default_yml, :rubocop, 'crema:check']

require 'yard'
require 'rubocop-on-rbs'
require 'rubocop/cops_documentation_generator'

class CopsDocumentationGeneratorOnRBS < CopsDocumentationGenerator
  private

  def examples(example_objects, cop)
    @current_cop = cop
    super
  end

  def code_example(code)
    lang = @current_cop.to_s.start_with?('RuboCop::Cop::RBSInline::') ? 'ruby' : 'rbs'
    content = "[source,#{lang}]\n----\n"
    content << code.text.gsub('@good', '# good').gsub('@bad', '# bad').strip
    content << "\n----\n"
    content
  end
end

YARD::Rake::YardocTask.new(:yard_for_generate_documentation) do |task|
  task.files = ['lib/rubocop/cop/**/*.rb']
  task.options = ['--no-output']
end

CREMA_BASELINE = 'crema-check-tamped.jsonl'

namespace :crema do
  # crema exits 1 when any diagnostic exists, which is expected here.
  def crema_tamped_diagnostics
    require 'open3'
    out, _status = Open3.capture2('crema', 'check', '--tamp')
    out.lines(chomp: true)
  rescue Errno::ENOENT
    abort 'crema is not installed. See https://github.com/ksss/crema'
  end

  desc 'Update crema tamped jsonl'
  task :tamping do
    File.write(CREMA_BASELINE, crema_tamped_diagnostics.join("\n") + "\n")
  end

  desc 'Check crema diagnostics do not increase against the baseline'
  task :check do
    before = File.readlines(CREMA_BASELINE, chomp: true)
    after = crema_tamped_diagnostics
    removed = before - after
    added = after - before

    unless removed.empty?
      warn "crema diagnostics resolved. Run 'rake crema:tamping' and commit #{CREMA_BASELINE} to update the baseline."
      warn removed
    end
    unless added.empty?
      warn "New crema diagnostics found. Fix them, or run 'rake crema:tamping' and commit #{CREMA_BASELINE}."
      warn added
      abort
    end
    puts 'crema diagnostics OK'
  end
end

desc 'Update Cops Documentation'
task update_cops_documentation: :yard_for_generate_documentation do
  rm_rf('docs/')

  departments = [
    'RBS/Layout',
    'RBS/Lint',
    'RBS/Style',
    'RBSInline/Lint',
    'RBSInline/Style'
  ]
  CopsDocumentationGeneratorOnRBS.new(departments: departments, plugin_name: 'rubocop-on-rbs').call
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
