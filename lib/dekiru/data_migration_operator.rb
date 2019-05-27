require 'ruby-progressbar'

module Dekiru
  class DataMigrationOperator
    attr_reader :title, :stream, :result, :canceled, :started_at, :ended_at, :error

    def self.execute(title, options = {}, &block)
      self.new(title, options).execute(&block)
    end

    def initialize(title, options = {})
      @title = title
      @stream = options[:output] || $stdout
    end

    def log(message)
      stream.puts(message)
    end

    def execute(&block)
      @started_at = Time.current
      log "Start: #{title} at #{started_at}\n\n"
      @result = ActiveRecord::Base.transaction(requires_new: true) do
        instance_eval(&block)
        confirm?("\nAre you sure to commit?")
      end
      log "Finished successfully: #{title}" if @result == true
    rescue => e
      @error = e
      @result = false
    ensure
      @ended_at = Time.current
      log "Total time: #{self.duration.round(2)} sec"

      raise error if error

      return @result
    end

    def duration
      ((self.ended_at || Time.current) - self.started_at)
    end

    def find_each_with_progress(target_scope, options = {})
      opt = {
        format: '%a |%b>>%i| %p%% %t',
      }.merge(options).merge(
        total: target_scope.count,
        output: stream
      )
      pb = ::ProgressBar.create(opt)
      target_scope.find_each do |target|
        yield target
        pb.increment
      end
      pb.finish
    end

    def confirm?(message = 'Are you sure?')
      loop do
        stream.print "#{message} (yes/no) > "
        case STDIN.gets.strip
        when 'yes'
          newline
          return true
        when 'no'
          newline
          cancel!
        end
      end
    end

    def newline
      log ''
    end

    def cancel!
      log "Canceled: #{title}"
      raise ActiveRecord::Rollback
    end
  end
end
