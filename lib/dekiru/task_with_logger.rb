module TaskWithLogger
  refine Rake::DSL do
    private

      def task(*args, &block)
        scope_path = Rake.application.current_scope.path
        new_block = proc do
          __echo__ "[START] #{scope_path}: #{args.inspect} (#{Time.current})"
          yield
          __echo__ "[END] #{scope_path}: #{args.inspect} (#{Time.current})"
        end
        super(*args, &new_block)
      end

      def __echo__(str)
        Rails.logger.info(str)
        puts(str)
      end
  end
end
