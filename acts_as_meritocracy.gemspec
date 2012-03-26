# -*- encoding: utf-8 -*-

lib = File.expand_path('../lib', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'acts_as_meritocracy/version'

Gem::Specification.new do |s|
  s.name = "acts_as_meritocracy"
  s.version = ActsAsMeritocracy::VERSION

  s.required_rubygems_version = '>= 1.9.0'
  s.homepage = "https://github.com/nmaisonneuve/acts_as_meritocracy"
  s.summary = "Weighted voting system for deliberation."
  s.description = "Weighted majority voting system for qualitative (categorical) items (i.e.assuming the set of decision has no natural ordering). As a measure of the quality of the consensus/inter-agreement, you can choose between a weighted variant of fleiss Kappa  (by default) or the entropy of the vote distribution"
  s.authors = ["Nicolas Maisonneuve"]
  s.email = ["n.maisonneuve.com"]
  s.files = Dir.glob("{lib,rails,test}/**/*") + %w(Gemfile MIT-LICENSE README.rdoc Rakefile)
  s.require_paths = ["lib"]

  s.add_runtime_dependency('activerecord')
  s.add_development_dependency('bundler')
  s.add_development_dependency('sqlite3')
  s.add_development_dependency('rake')

end