# -*- encoding: utf-8 -*-

lib = File.expand_path('../lib', __FILE__)
$:.unshift lib unless $:.include?(lib)


Gem::Specification.new do |s|
  s.name = "acts_as_meritocracy"
  s.version = "0.1"

  s.required_rubygems_version = '>= 1.8.0'
  s.homepage = ""
  s.summary = "Weighted voting system for deliberation."
  s.description = ""
  s.authors = ["Nicolas Maisonneuve"]
  s.email = ["n.maisonneuve.com"]
  s.files = Dir.glob("{lib,rails,test}/**/*") + %w(CHANGELOG.md Gemfile MIT-LICENSE README.md Rakefile)
  s.require_paths = ["lib"]

  s.add_runtime_dependency('activerecord')
  s.add_development_dependency('bundler')
  s.add_development_dependency('sqlite3')
  s.add_development_dependency('rake')

end