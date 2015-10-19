class SmtpCheckMailer < ActionMailer::Base
  default from: "smtp-checker@sonicgarden.jp"

  def checkmail
    @app_key = ENV['SMTP_CHECKER_APP_KEY']
    subject = "[SMTP Checker] SMTP Check Mail"

    mail to: ENV['SMTP_CHECKER_TO_ADDR'], subject: subject
  end
end
