#!/usr/bin/env rake
begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

#APP_RAKEFILE = File.expand_path("../sandbox/Rakefile", __FILE__)
#load 'rails/tasks/engine.rake'
#


Bundler::GemHelper.install_tasks

require "rake/testtask"

# desc "Testing"
#
# task :test do
#   1
# end

Rake::TestTask.new() do |t|
  t.libs << "test"
  t.pattern = "test/**/*_test.rb"
end

task :default => :test
