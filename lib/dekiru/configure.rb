module Dekiru
  def self.configure(&block)
    @configure ||= Configure.new
    yield @configure if block_given?
    @configure
  end

  class Configure
    attr_accessor :monitor_email, :monitor_api_key, :error_handle
    def initialize
      @error_handle = -> (e) {}
    end
  end
end
