module Dekiru
  class MailSecurityInterceptor

    class Dekiru::MailSecurityInterceptor::NoToAdreessError < StandardError ; end
    def delivering_email(mail)
      if mail.to.blank?
        raise Dekiru::MailSecurityInterceptor::NoToAdreessError
      end
    end
  end
end
