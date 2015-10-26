module Dekiru
  class SmtpCheckMailer < ActionMailer::Base
    default from: "smtp-checker@sonicgarden.jp"

    def checkmail
      app_key = ENV['SMTP_CHECKER_APP_KEY'] || Rails.application.class.parent_name
      smtp_checker_to_addr = ENV['SMTP_CHECKER_TO_ADDR'] || 'smtp-check@sg-ops-mail.sonicgarden.jp'

      Rails.logger.error "ENV['SMTP_CHECKER_APP_KEY'] undefined!" if app_key.blank?
      Rails.logger.error "ENV['SMTP_CHECKER_TO_ADDR'] undefined!" if smtp_checker_to_addr.blank?

      Rails.logger.info "checkmail send start #{smtp_checker_to_addr} key:#{smtp_checker_to_addr}"
      subject = "[SMTP Checker] SMTP Check Mail"
      mail to: smtp_checker_to_addr, subject: subject do |format|
        format.text { render plain: app_key }
      end
      Rails.logger.info "send to #{smtp_checker_to_addr} key:#{smtp_checker_to_addr}"
    end
  end
end

