desc 'smtp check'
task sendmail_smtpcheck: :environment do
  Rails.logger.info "[INFO] Start smtpcheck:send_checkmail"
  Rails.logger.error "ENV['SMTP_CHECKER_APP_KEY'] undefined!" if ENV['SMTP_CHECKER_APP_KEY'].blank?
  Rails.logger.error "ENV['SMTP_CHECKER_TO_ADDR'] undefined!" if ENV['SMTP_CHECKER_TO_ADDR'].blank?

  Dekiru::SmtpCheckMailer::checkmail
end
