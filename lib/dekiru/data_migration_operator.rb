require 'ruby-progressbar'

module Dekiru
  class DataMigrationOperator
    class NestedTransactionError < StandardError ; end

    attr_reader :title, :stream, :logger, :result, :canceled, :started_at, :ended_at, :error

    def self.execute(title, options = {}, &block)
      self.new(title, options).execute(&block)
    end

    def initialize(title, options = {})
      @title = title
      @options = options
      @logger = @options.fetch(:logger) { Logger.new(Rails.root.join("log/data_migration_#{Time.current.strftime("%Y%m%d%H%M")}.log")) }
      @stream = @options.fetch(:output, $stdout)
      @without_transaction = @options.fetch(:without_transaction, false)
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
        raise NestedTransactionError if current_transaction_open?

        @result = ActiveRecord::Base.transaction do
          run(&block)
          log "Finished execution: #{title}"
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

    def each_with_progress(enum, options = {})
      options = options.dup
      options[:total] ||= ((enum.size == Float::INFINITY ? nil : enum.size) rescue nil)
      options[:format] ||= options[:total] ? '%a |%b>>%i| %p%% %t' : '%a |%b>>%i| ??%% %t'
      options[:output] = stream

      @pb = ::ProgressBar.create(options)
      enum.each do |item|
        yield item
        @pb.increment
      end
      @pb.finish
    end

    def find_each_with_progress(target_scope, options = {}, &block)
      # `LocalJumpError: no block given (yield)` が出る場合、 find_each メソッドが enumerator を返していない可能性があります
      # 直接 each_with_progress を使うか、 find_each が enumerator を返すように修正してください
      each_with_progress(target_scope.find_each, options, &block)
    end

    private

    def current_transaction_open?
      ActiveRecord::Base.connection.current_transaction.open?
    end

    def log(message)
      if @pb && !@pb.finished?
        @pb.log(message)
      else
        stream.puts(message)
      end

      logger&.info(message.squish)
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
      stream.puts('')
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
      if @options.fetch(:warning_side_effects, true)
        warning_side_effects(&block)
      else
        instance_eval(&block)
      end
    end
  end
end
