# encoding: UTF-8
require 'rubygems'
require 'bundler' unless defined?(Bundler)

$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)

begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'


require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.test_files = Dir.glob("test/**/*_test.rb")
  test.verbose = true
end

task :build do
  system "gem build acts_as_meritocracy.gemspec"
end

task :release => :build do
  system "gem push acts_as_meritocracy-0.1.gem"
  system "rm acts_as_meritocracy-0.1.gem"
end

task :default => :test