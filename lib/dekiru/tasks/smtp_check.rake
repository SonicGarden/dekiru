require "dekiru/smtp_check_mailer"

namespace :dekiru do
  desc 'Ops check for smpt alival'
  task smtp_check: :environment do
    Rails.logger.info "[INFO] Start task dekiru:smtp_check env:#{Rails.env}"
    Dekiru::SmtpCheckMailer.checkmail.deliver
    Rails.logger.info "[INFO] End task dekiru:smtp_check env:#{Rails.env}"
  end
end
