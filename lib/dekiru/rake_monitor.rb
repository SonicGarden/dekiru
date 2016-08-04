module Dekiru
  module RakeMonitor
    def resolve_args(args)
      estimate_time = args.first.delete(:estimate_time)
      [args, estimate_time]
    end

    def conn
      @conn ||= Faraday.new(:url => 'https://job-mon.herokuapp.com') do |faraday|
        faraday.request  :url_encoded
        faraday.request  :json
        faraday.response :json
        faraday.adapter  Faraday.default_adapter
      end
    end

    def api_key
      Dekiru.configure.monitor_api_key
    end

    def monitor_email
      Dekiru.configure.monitor_email
    end

    def job_start(task, estimate_time)
      body = {
        job: {
          name: task.name,
          end_time: Time.current.since(estimate_time),
          email: monitor_email
        }
      }
      response = conn.post "/api/apps/#{api_key}/jobs.json", body
      response.body["id"]
    rescue => e
      Dekiru.configure.error_handle.call(e)
      nil
    end

    def job_end(job_id)
      if job_id
        response = conn.put "/api/apps/#{api_key}/jobs/#{job_id}/finished.json", nil
      end
    end

    def task_with_monitor(*args, &block)
      args, estimate_time = resolve_args(args)
      task *args do |t|
        job_id = job_start(t, estimate_time)
        block.call
        job_end(job_id)
      end
    end
  end
end

self.extend Dekiru::RakeMonitor
