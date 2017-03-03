module Dekiru
  module Capybara
    module Helpers
      def wait_for_bs_modal
        script = <<~EOS
          window._capybaraModalWait = 1;
          jQuery(document).one("shown.bs.modal", function(){window._capybaraModalWait = 0;});
        EOS
        page.execute_script(script)
        yield
        Timeout.timeout(::Capybara.default_max_wait_time) do
          loop until page.evaluate_script('window._capybaraModalWait').zero?
        end
      end

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
