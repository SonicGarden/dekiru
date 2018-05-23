namespace :db do
  namespace :migrate do
    desc 'Check migrate conflict'
    task check_conflict: :environment do
      migrations_status =
        if ActiveRecord::Base.connection.respond_to?(:migration_context)
          ActiveRecord::Base.connection.migration_context.migrations_status
        else
          paths = ActiveRecord::Tasks::DatabaseTasks.migrations_paths
          ActiveRecord::Migrator.migrations_status(paths)
        end

      if migrations_status.map(&:third).any? { |name| name.include?('NO FILE') }
        abort 'Migration conflict!'
      end
    end
  end
end
