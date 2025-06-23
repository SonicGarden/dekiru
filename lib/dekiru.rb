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
  end

  class Configuration
    attr_accessor :mail_security_hook

    def initialize
      @mail_security_hook = false # default
    end
  end
end
