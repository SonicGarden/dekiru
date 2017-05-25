#!/usr/bin/env rake
require "bundler/gem_tasks"
require 'rspec/core/rake_task'

task :default => :spec

RSpec::Core::RakeTask.new do |t|
  t.rspec_opts = ['--color', "--format progress"]
  t.pattern = 'spec/dekiru/**/*_spec.rb'
end
