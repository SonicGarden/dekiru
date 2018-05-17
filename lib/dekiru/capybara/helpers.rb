module Dekiru
  module Capybara
    module Helpers
      class Error < StandardError; end

      def wait_for_event(event)
        page.execute_script(<<~"EOS")
          (function(){
            var eventName = '#{event}';
            window._dekiruCapybaraWaitEvents = window._dekiruCapybaraWaitEvents || {};
            window._dekiruCapybaraWaitEvents[eventName] = 1;
            jQuery(document).one(eventName, function(){window._dekiruCapybaraWaitEvents[eventName] = 0;});
          })();
        EOS
        yield

        script = <<~"EOS"
          (function(){
            var eventName = '#{event}';
            return window._dekiruCapybaraWaitEvents && window._dekiruCapybaraWaitEvents[eventName];
          })();
        EOS
        wait_until do
          result = page.evaluate_script(script)
          raise Error, 'wait_for_event: Missing context. probably moved to another page.' if result.nil?
          result == 0
        end
      end

      # https://robots.thoughtbot.com/automatically-wait-for-ajax-with-capybara
      def wait_for_ajax
        wait_until { finished_all_ajax_requests? }
      end

      def finished_all_ajax_requests?
        page.evaluate_script('jQuery.active').zero?
      end

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
