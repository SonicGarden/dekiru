class SmtpCheckMailer < ActionMailer::Base
  default from: "smtp-checker@sonicgarden.jp"

  def checkmail(app_key)
    @app_key = app_key
    subject = "[SMTP Checker] メール送信チェック"

    mail to: ENV['SMTP_CHECKER_TO_ADDR'], subject: subject
  end
end
