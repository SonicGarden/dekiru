module Dekiru
  module Capybara
    module Matchers
      class JsNoErrorMatcher
        def initialize(example_description)
          @example_description = example_description
        end

        def matches?(page_or_logs)
          logs = if page_or_logs.respond_to?(:driver)
                   page_or_logs.driver.browser.logs.get(:browser)
                 else
                   page_or_logs
                 end
          logs.find_all { |log| log.level == 'WARNING' }.each do |log|
            STDERR.puts "WARN: javascript warning in #{@example_description}"
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
        # NOTE: Extract "\"displays tooltip\" (./spec/system/my_awesome_spec.rb:101)"
        # From "#<RSpec::ExampleGroups::Nested::Nested_4::Nested_4 \"displays tooltip\" (./spec/system/my_awesome_spec.rb:101)>"
        example_description = self.inspect.split(' ', 2).last.chop

        JsNoErrorMatcher.new(example_description)
      end
    end
  end
end
