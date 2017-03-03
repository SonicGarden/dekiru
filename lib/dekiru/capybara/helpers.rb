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
        Timeout.timeout(::Capybara.default_max_wait_time) do
          script = <<~"EOS"
            (function(){
              var eventName = '#{event}';
              return window._dekiruCapybaraWaitEvents && window._dekiruCapybaraWaitEvents[eventName];
            })();
          EOS
          begin
            result = page.evaluate_script(script)
            raise Error, 'wait_for_event: Missing context. probably moved to another page.' if result.nil?
          end while result == 1
        end
      end

      # https://robots.thoughtbot.com/automatically-wait-for-ajax-with-capybara
      def wait_for_ajax
        Timeout.timeout(::Capybara.default_max_wait_time) do
          loop until finished_all_ajax_requests?
        end
      end

      def finished_all_ajax_requests?
        page.evaluate_script('jQuery.active').zero?
      end
    end
  end
end
