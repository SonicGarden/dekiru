require 'ruby-progressbar'

module Dekiru
  class DataMigrationOperator
    attr_reader :title, :stream, :result, :canceled, :started_at, :ended_at, :error

    def self.execute(title, options = {}, &block)
      self.new(title, options).execute(&block)
    end

    def initialize(title, options = {})
      @title = title
      @options = options
      @stream = @options[:output] || $stdout
      @without_transaction = @options[:without_transaction] || false
      @side_effects = Hash.new do |hash, key|
        hash[key] = Hash.new(0)
      end
    end

    def execute(&block)
      @started_at = Time.current
      log "Start: #{title} at #{started_at}\n\n"
      if @without_transaction
        run(&block)
        @result = true
      else
        @result = ActiveRecord::Base.transaction(requires_new: true, joinable: false) do
          run(&block)
          confirm?("\nAre you sure to commit?")
        end
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
      total = options.delete(:total)
      opt = {
        format: '%a |%b>>%i| %p%% %t',
      }.merge(options).merge(
        total: total || target_scope.count,
        output: stream
      )
      pb = ::ProgressBar.create(opt)
      target_scope.find_each do |target|
        yield target
        pb.increment
      end
      pb.finish
    end

    private

    def log(message)
      stream.puts(message)
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

    def handle_notification(*args)
      event = ActiveSupport::Notifications::Event.new(*args)

      increment_side_effects(:enqueued_jobs, event.payload[:job].class.name)  if event.payload[:job]
      increment_side_effects(:deliverd_mailers, event.payload[:mailer]) if event.payload[:mailer]

      if event.payload[:sql] && /\A\s*(insert|update|delete)/i.match?(event.payload[:sql])
        increment_side_effects(:write_queries, event.payload[:sql])
      end
    end

    def increment_side_effects(type, value)
      @side_effects[type][value] += 1
    end

    def warning_side_effects(&block)
      ActiveSupport::Notifications.subscribed(method(:handle_notification), /^(sql|enqueue|deliver)/) do
        instance_eval(&block)
      end

      @side_effects.each do |name, items|
        newline
        log "#{name.to_s.titlecase}!!"
        items.sort_by { |v, c| c }.reverse.slice(0, 20).each do |value, count|
          log "#{count} call: #{value}"
        end
      end
    end

    def run(&block)
      if @options[:warning_side_effects]
        warning_side_effects(&block)
      else
        instance_eval(&block)
      end
    end
  end
end
