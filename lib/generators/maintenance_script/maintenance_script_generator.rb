require 'rails/generators'

class MaintenanceScriptGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('templates', __dir__)

  def copy_maintenance_script_file
    script_filename = "#{filename_date}_#{file_name}.rb"
    @prefix = Dekiru.configuration.maintenance_script_prefix&.call(script_filename)
    template 'maintenance_script.rb.erb',
             "#{Dekiru.configuration.maintenance_script_directory}/#{script_filename}"
  end

  private

  def filename_date
    Time.current.strftime('%Y%m%d')
  end
end
