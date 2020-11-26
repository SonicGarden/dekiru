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
      @side_effects = Hash.new { |hash, key| hash[key] = [] }
    end

    def execute(&block)
      @started_at = Time.current
      log "Start: #{title} at #{started_at}\n\n"
      @result = ActiveRecord::Base.transaction(requires_new: true, joinable: false) do
        ActiveSupport::Notifications.subscribed(method(:handle_notification), /^(sql|enqueue|deliver)/) do
          instance_eval(&block)
        end
        print_side_effects
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

      @side_effects[:enqueued_jobs] << event.payload[:job].class.name if event.payload[:job]
      @side_effects[:deliverd_mailers] << event.payload[:mailer] if event.payload[:mailer]

      if event.payload[:sql] && /\A\s*(insert|update|delete)/i.match?(event.payload[:sql])
        @side_effects[:danger_queries] << event.payload[:sql]
      end
    end

    def print_side_effects
      @side_effects.each do |name, items|
        newline
        log "#{name.to_s.titlecase}!!"
        log count_by_items(items).inspect
      end
    end

    def count_by_items(items)
      items.group_by(&:itself).map {|k, v| [v.size, k] }.sort_by { |count, _q| count }
    end
  end
end
