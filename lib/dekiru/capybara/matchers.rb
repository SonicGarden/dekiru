module Dekiru
  module Capybara
    module Matchers
      class JsNoErrorMatcher
        def matches?(page_or_logs)
          logs = page_or_logs.respond_to?(:driver) ? page_or_logs.driver.browser.logs.get(:browser) : page_or_logs
          logs.find_all { |log| log.level == 'WARNING' }.each do |log|
            STDERR.puts 'WARN: javascript warning'
            STDERR.puts log.message
          end

          @severe_errors = logs.find_all { |log| log.level == 'SEVERE' }
          @severe_errors.empty?
        end

        def description
          'have no js errors'
        end

        def failure_message
          @severe_errors.map(&:message).join("\n")
        end
      end

      def have_no_js_errors
        JsNoErrorMatcher.new
      end
    end
  end
end
