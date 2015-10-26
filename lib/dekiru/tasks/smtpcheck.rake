desc 'smtp check'
task sendmail_smtpcheck: :environment do
  Rails.logger.info "[INFO] Start smtpcheck:sendmail_smtpcheck env:#{Rails.env}"

  SmtpCheckMailer.checkmail.deliver
  Rails.logger.info "[INFO] End smtpcheck:sendmail_smtpcheck env:#{Rails.env}"
end
