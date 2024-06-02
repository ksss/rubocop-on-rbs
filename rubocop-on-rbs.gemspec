# frozen_string_literal: true

require_relative 'lib/rubocop/rbs/version'

Gem::Specification.new do |spec|
  spec.name = 'rubocop-on-rbs'
  spec.version = Rubocop::RBS::VERSION
  spec.authors = ['ksss']
  spec.email = ['co000ri@gmail.com']

  spec.summary = ''
  spec.description = ''
  spec.homepage = 'https://github.com/ksss/rubocop-on-rbs'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 3.1.0'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile rbs_collection Steepfile sig])
    end
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'rbs'
  spec.add_dependency 'rubocop'
  spec.metadata['rubygems_mfa_required'] = 'true'
end
