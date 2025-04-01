require 'dekiru/version'
require 'dekiru/railtie' if defined?(::Rails)
require 'dekiru/helper'
require 'dekiru/data_migration_operator'
require 'dekiru/mail_security_interceptor'
require 'dekiru/camelize_hash'
require 'dekiru/transaction_provider'

require 'active_support'
require 'active_support/all'

module Dekiru
  class << self
    def configure
      yield(configuration)
    end

    def configuration
      @configuration ||= Configuration.new
    end
  end

  class Configuration
    attr_accessor :mail_security_hook, :maintenance_script_directory, :transaction_provider

    def initialize
      @mail_security_hook = false # default
      @maintenance_script_directory = 'scripts'
      @transaction_provider = TransactionProvider.new
    end
  end
end
