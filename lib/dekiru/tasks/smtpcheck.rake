desc 'smtp check'
task sendmail_smtpcheck: :environment do
  Rails.logger.info "[INFO] Start smtpcheck:sendmail_smtpcheck env:#{Rails.env}"
  Rails.logger.error "ENV['SMTP_CHECKER_APP_KEY'] undefined!" if ENV['SMTP_CHECKER_APP_KEY'].blank?
  Rails.logger.error "ENV['SMTP_CHECKER_TO_ADDR'] undefined!" if ENV['SMTP_CHECKER_TO_ADDR'].blank?

  class SmtpCheckMailer < ActionMailer::Base
    default from: "smtp-checker@sonicgarden.jp"
    def checkmail
      Rails.logger.error "checkmaul send start #{ENV['SMTP_CHECKER_TO_ADDR']} key:#{ENV['SMTP_CHECKER_APP_KEY']}"
      subject = "[SMTP Checker] SMTP Check Mail"
      mail to: ENV['SMTP_CHECKER_TO_ADDR'], subject: subject do |format|
        format.text { render plain: "#{ENV['SMTP_CHECKER_APP_KEY']}" }
      end
      Rails.logger.error "send to #{ENV['SMTP_CHECKER_TO_ADDR']} key:#{ENV['SMTP_CHECKER_APP_KEY']}"
    end
  end

  SmtpCheckMailer::checkmail
  Rails.logger.info "[INFO] End smtpcheck:sendmail_smtpcheck env:#{Rails.env}"
end
