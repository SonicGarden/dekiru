require 'dekiru/job_mon_client'

namespace :dekiru do
  desc 'Ops monitor for Delayed::Job queue for job-mon'
  task delayed_job_queue_monitor: :environment do
    Rails.logger.info "[INFO] Start dekiru:delayed_job_queue_monitor env:#{Rails.env}"
    if defined?(Delayed::Job)
      count = Delayed::Job.where('run_at < ? or last_error IS NOT NULL', 30.seconds.since).count
      Dekiru::JobMonClient.new.send_queue_log(count)
    end
    Rails.logger.info "[INFO] End dekiru:delayed_job_queue_monitor env:#{Rails.env}"
  end
end
