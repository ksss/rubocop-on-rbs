# -*- encoding: utf-8 -*-
# stub: rbs-inline 0.11.0 ruby lib

Gem::Specification.new do |s|
  s.name = "rbs-inline".freeze
  s.version = "0.11.0".freeze

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.metadata = { "changelog_uri" => "https://github.com/soutaro/rbs-inline/blob/master/CHANGELOG.md", "homepage_uri" => "https://github.com/soutaro/rbs-inline", "source_code_uri" => "https://github.com/soutaro/rbs-inline" } if s.respond_to? :metadata=
  s.require_paths = ["lib".freeze]
  s.authors = ["Soutaro Matsumoto".freeze]
  s.bindir = "exe".freeze
  s.date = "2025-03-06"
  s.description = "Inline RBS type declaration.".freeze
  s.email = ["matsumoto@soutaro.com".freeze]
  s.executables = ["rbs-inline".freeze]
  s.files = ["exe/rbs-inline".freeze]
  s.homepage = "https://github.com/soutaro/rbs-inline".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 3.1.0".freeze)
  s.rubygems_version = "3.6.2".freeze
  s.summary = "Inline RBS type declaration.".freeze

  s.installed_by_version = "3.6.7".freeze

  s.specification_version = 4

  s.add_runtime_dependency(%q<prism>.freeze, [">= 0.29".freeze, "< 1.3".freeze])
  s.add_runtime_dependency(%q<rbs>.freeze, [">= 3.5.0".freeze])
end
