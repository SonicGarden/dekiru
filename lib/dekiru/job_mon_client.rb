module Dekiru
  class JobMonClient
    def host
      'https://job-mon.herokuapp.com'
    end
    def conn
      @conn ||= Faraday.new(:url => host) do |faraday|
        faraday.request  :url_encoded
        faraday.request  :json
        faraday.response :json
        faraday.adapter  Faraday.default_adapter
      end
    end

    def api_key
      Dekiru.configure.monitor_api_key
    end

    def job_start(task, estimate_time, monitor_email)
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

    def send_queue_log(count)
      body = {
        queue_log: {
          count: count
        }
      }
      response = conn.post "/api/apps/#{api_key}/queue_logs.json", body
      response.body["id"]
    rescue => e
      Dekiru.configure.error_handle.call(e)
      nil
    end
  end
end

