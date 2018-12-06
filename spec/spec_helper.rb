require 'rubygems'
require 'rspec'

# For rails app
require 'rails'
require "active_support"
require 'active_support/core_ext/object'
require "active_record"
require "action_view"
require "action_view/helpers"
require 'action_mailer'

PROJECT_ROOT = File.expand_path(File.join(File.dirname(__FILE__), '..'))

$LOAD_PATH << File.join(PROJECT_ROOT, 'lib')

require 'dekiru'
Dir.glob(File.join(PROJECT_ROOT, 'spec/supports/**/*.rb')).each { |f| require f }

RSpec.configure do |config|
end

# ActionMailerのテストを
