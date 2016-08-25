require 'rails/generators'
require 'dekiru/job_mon_client'

class DekiruGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)

  desc 'Configures the dekiru job monitor'
  def create_initializer_file
    initializer 'dekiru.rb' do
      <<-EOF
Dekiru.configure do |config|
  config.monitor_email   = "support+#{fetch_app_name}@sonicgarden.jp"
  config.monitor_api_key = "#{fetch_api_key}"
  config.error_handle    = -> (e) { Bugsnag.notify(e) }
end
      EOF
    end
  end

  def client
    @client ||= Dekiru::JobMonClient.new
  end

  private

  def fetch_api_key
    res = client.conn.post '/api/apps.json', app: { name: fetch_app_name }
    res.body['api_key']
  end

  def fetch_app_name
    File.basename(Rails.root)
  end
end
