module TaskWithLogger
  refine Rake::DSL do
    private

      def task(*args, &block)
        new_block = proc do |_task, _args|
          TaskWithLogger.echo("[START] #{_task.name} #{_args.to_h} (#{Time.current})")
          yield(_task, _args)
          TaskWithLogger.echo("[END] #{_task.name} #{_args.to_h} (#{Time.current})")
        end
        super(*args, &new_block)
      end
  end

  def echo(str)
    Dekiru.deprecator.warn("TaskWithLogger is deprecated. If necessary, copy it to your project and use it.")
    Rails.logger.info(str)
    puts(str)
  end
  module_function :echo
end
