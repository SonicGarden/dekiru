module Dekiru
  class Railtie < ::Rails::Railtie
    initializer 'dekiru' do |app|
      ActiveSupport.on_load(:action_view) do
        ::ActionView::Base.send :include, Dekiru::Helper
      end

      ActiveSupport.on_load(:action_controller) do
        ::ActionController::Base.send :include, Dekiru::ControllerAdditions
      end
    end

    rake_tasks do
      load "dekiru/tasks/smtp_check.rake"
      load "dekiru/tasks/delayed_job_queue_check.rake"
    end
  end
end
