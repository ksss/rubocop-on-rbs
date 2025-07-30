# frozen_string_literal: true

require_relative 'lib/rubocop/rbs/version'

Gem::Specification.new do |spec|
  spec.name = 'rubocop-on-rbs'
  spec.version = RuboCop::RBS::VERSION
  spec.authors = ['ksss']
  spec.email = ['co000ri@gmail.com']

  spec.summary = 'RuboCop extension for RBS file.'
  spec.description = 'RuboCop extension for RBS file.'
  spec.homepage = 'https://github.com/ksss/rubocop-on-rbs'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 3.2.0'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['changelog_uri'] = spec.homepage
  spec.metadata['default_lint_roller_plugin'] = 'RuboCop::RBS::Plugin'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).select do |f|
      f.start_with?(*%w[lib/ config/ CHANGELOG.md CODE_OF_CONDUCT.md LICENSE.txt README.md])
    end
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'lint_roller', '~> 1.1'
  spec.add_dependency 'rbs', '4.0.0.dev.4'
  spec.add_dependency 'rubocop', '>= 1.72.1', '< 2.0'
  spec.add_dependency 'zlib'
  spec.metadata['rubygems_mfa_required'] = 'true'
end
