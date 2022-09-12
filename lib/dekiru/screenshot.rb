module Dekiru
  class Screenshot
    class Configuration
      attr_accessor :enabled, :root_dir, :window_size

      def initialize
        @enabled = ENV.has_key?('TAKE_SCREENSHOT')
        @root_dir = Rails.root.join('tmp/screenshots')
        @window_size = OpenStruct.new(
          width: 1024,
          height: 768,
        )
      end

      def enabled?
        !!@enabled
      end
    end

    class << self
      def configure
        yield configuration
      end

      def configuration
        @configuration ||= Configuration.new
      end
    end

    attr_accessor :example

    def configuration
      self.class.configuration
    end

    def take(page:, name: nil, suffix: '')
      root_dir = configuration.root_dir
      file_path = File.join(root_dir, "#{[name, suffix].reject(&:blank?).join('_')}.png")
      FileUtils.mkdir_p(File.dirname(file_path))

      width = configuration.window_size.width
      height = begin
                 page.evaluate_script('document.querySelector("body").clientHeight')
               rescue
                 configuration.window_size.height
               end

      temporary_resize(page, width, height) do
        page.save_screenshot(file_path)
      end
    end

    def temporary_resize(page, width, height)
      tmp_width = page.driver.browser.manage.window.size.width
      tmp_height = page.driver.browser.manage.window.size.height
      handle = ::Capybara.current_session.driver.current_window_handle

      page.driver.resize_window_to(handle, width, height)
      yield
      page.driver.resize_window_to(handle, tmp_width, tmp_height)
    end
  end
end
