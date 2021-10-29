module Dekiru
  module Capybara
    module Helpers
      module WaitForPositionStable
        class StableTimer
          def initialize(wait)
            @wait = wait
            @stable = false
            @start_time = nil
            @prev_obj = nil
          end

          def stable?(obj)
            if @prev_obj && @prev_obj == obj
              if @start_time.nil?
                @start_time = current
              elsif current - @start_time > @wait
                return true
              end
            else
              @start_time = nil
            end
            @prev_obj = obj
            false
          end

          private

          def current
            ::Capybara::Helpers.monotonic_time
          end
        end

        def wait_for_element_position_stable(element, wait: ::Capybara.default_max_wait_time, stable_wait: 0.5)
          stable_timer = StableTimer.new(stable_wait)
          timer = ::Capybara::Helpers.timer(expire_in: wait)
          loop do
            rect = element.rect
            break if stable_timer.stable?(rect)
            raise 'Timeout to wait animation finished' if timer.expired?

            sleep 0.1
          end
        end

        def wait_for_position_stable(selector, locator, **options)
          element = find(selector, locator, **options.except(:stable_wait))
          wait_for_element_position_stable(element, **options.slice(:wait, :stable_wait))
        end
      end
    end
  end
end
