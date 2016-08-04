#!/usr/bin/env rake
require "bundler/gem_tasks"
require 'rspec/core/rake_task'

task :default => :spec

RSpec::Core::RakeTask.new do |t|
  t.rspec_opts = ['--color', "--format progress"]
  t.pattern = 'spec/dekiru/**/*_spec.rb'
end

require 'dekiru'
require 'dekiru/rake_monitor'

Dekiru.configure do |config|
  config.monitor_email = "email@example.com"
  config.monitor_api_key = "0680fa6b-c014-4985-8d05-1cca2d50512b"
  config.error_handle = -> (e) {
    puts e
  }
end

task_with_monitor job: nil, estimate_time: 10 do
  puts "execute"
end
