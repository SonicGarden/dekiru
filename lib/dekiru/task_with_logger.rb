module TaskWithLogger
  refine Rake::DSL do
    private

      def task(*args, &block)
        new_block = proc do |_task, _args|
          __echo__ "[START] #{_task.name} #{_args.to_h} (#{Time.current})"
          yield(_task, _args)
          __echo__ "[END] #{_task.name} #{_args.to_h} (#{Time.current})"
        end
        super(*args, &new_block)
      end

      def __echo__(str)
        Rails.logger.info(str)
        puts(str)
      end
  end
end
