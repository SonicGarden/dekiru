require 'dekiru/capybara/helpers/wait_for_position_stable'

module Dekiru
  module Capybara
    module Helpers
      include WaitForPositionStable

      def wait_until(timeout: ::Capybara.default_max_wait_time, interval: 0.2, **opts, &block)
        if defined?(Selenium::WebDriver::Wait)
          Selenium::WebDriver::Wait.new(opts.merge(timeout: timeout, interval: interval)).until { yield }
        else
          Timeout.timeout(timeout) do
            sleep(interval) until yield
          end
        end
      end
    end
  end
end
