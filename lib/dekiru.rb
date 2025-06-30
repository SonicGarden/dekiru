require 'dekiru/version'
require 'dekiru/railtie' if defined?(::Rails)
require 'dekiru/helper'
require 'dekiru/mail_security_interceptor'
require 'dekiru/camelize_hash'

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

    def deprecator
      @deprecator ||= ActiveSupport::Deprecation.new('1.2', 'Dekiru')
    end
  end

  class Configuration
    attr_reader :mail_security_hook

    def initialize
      @mail_security_hook = false # default
    end

    def mail_security_hook=(value)
      Dekiru.deprecator.warn('Dekiru.configuration.mail_security_hook is deprecated. If necessary, implement it yourself using after_action.')

      @mail_security_hook = value
    end
  end
end
