module Dekiru
  module Capybara
    module Matchers
      class JsErrorMatcher
        def matches?(page)
          errors = page.driver.browser.manage.logs.get(:browser)
          errors.find_all { |error| error.level == 'WARNING' }.each do |error|
            STDERR.puts 'WARN: javascript warning'
            STDERR.puts error.message
          end

          @severe_errors = errors.find_all { |error| error.level == 'SEVERE' }
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
        JsErrorMatcher.new
      end
    end
  end
end
