require "dekiru/version"
require "dekiru/railtie" if defined?(::Rails)
require "dekiru/helper"
require "dekiru/controller_additions"
require File.expand_path('../../app/mailers',        __FILE__)

module Dekiru
  class Railtie < ::Rails::Railtie
    rake_tasks do
      load "dekiru/tasks/smtpcheck.rake"
    end
  end
end
