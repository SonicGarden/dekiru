require 'dekiru/screenshot'

module Dekiru
  module Capybara
    module Helpers
      module TakeScreenshot
        def take_screenshot(name: nil, suffix: '')
          return unless ::Dekiru::Screenshot.configuration.enabled?

          filename = name.presence || @dekiru_example&.full_description&.gsub(' ', '/')
          current_dekiru_screenshot.take(page: page, name: filename, suffix: suffix)
        end

        def current_dekiru_screenshot
          @current_dekiru_screenshot ||= ::Dekiru::Screenshot.new
        end

        def dekiru_current_example(example)
          @dekiru_example = example
        end
      end
    end
  end
end

RSpec.configure do |config|
  %i[system feature].each do |type|
    config.before type: type do |example|
      dekiru_current_example(example)
    end
  end
end
