module Dekiru
  class Railtie < ::Rails::Railtie
    initializer 'dekiru' do |app|
      ActiveSupport.on_load(:action_view) do
        ::ActionView::Base.send :include, Dekiru::Helper
      end
    end

    config.after_initialize do
      if Dekiru.configuration.mail_security_hook
        Rails.logger.info '[dekiru] mail_security_hook enabled'
        interceptor = Dekiru::MailSecurityInterceptor.new
        ActionMailer::Base.register_interceptor(interceptor)
      end
    end

    rake_tasks do
      load 'dekiru/tasks/db.rake'
    end
  end
end
