namespace :dekiru do
  desc 'Ops check for Delayed::Job queue'
  task delayed_job_queue_check: :environment do
    Rails.logger.info "[INFO] Start dekiru:delayed_job_queue_check env:#{Rails.env}"
    if defined?(Delayed::Job)
      if (count = Delayed::Job.where('run_at < ? or last_error IS NOT NULL', 30.seconds.since).count) > 0
        message = "There are #{count} jobs that are not running for Delayed::Job. Check job list!"
        if defined?(Bugsnag)
          Bugsnag.notify(message)
        else
          fail(message)
        end
      end
    end
    Rails.logger.info "[INFO] End dekiru:delayed_job_queue_check env:#{Rails.env}"
  end
end
