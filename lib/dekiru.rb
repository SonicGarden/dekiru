require "dekiru/version"
require "dekiru/railtie" if defined?(::Rails)
require "dekiru/helper"
require "dekiru/controller_additions"

module Dekiru
  class Railtie < ::Rails::Railtie
    rake_tasks do
      load "dekiru/tasks/smtp_check.rake"
    end
  end
end
