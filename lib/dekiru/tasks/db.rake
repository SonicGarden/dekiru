namespace :db do
  namespace :migrate do
    desc 'Check migrate conflict'
    task check_conflict: :environment do
      migration_context =
          if ActiveRecord::Base.connection_pool.respond_to?(:migration_context)
            ActiveRecord::Base.connection_pool.migration_context
          else
            ActiveRecord::Base.connection.migration_context
          end
      migrations_status = migration_context.current_version.zero? ? [] : migration_context.migrations_status

      if migrations_status.map(&:third).any? { |name| name.include?('NO FILE') }
        abort 'Migration conflict!'
      end
    end
  end
end
