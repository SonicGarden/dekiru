require "spec_helper"

describe Dekiru::DataMigrationOperator do
  let(:dummy_stream) do
    class Dekiru::DummyStream
      attr_reader :out

      def initialize
        @out = ''
      end

      def puts(text)
        @out = out << "#{text}\n"
      end

      def print(text)
        @out = out << text
      end

      def tty?
        false
      end

      def flush
      end
    end
    Dekiru::DummyStream.new
  end
  let(:operator) { Dekiru::DataMigrationOperator.new('dummy', output: dummy_stream) }

  describe '#execute' do
    it 'confirm で yes' do
      allow(STDIN).to receive(:gets) do
        "yes\n"
      end

      expect do
        operator.execute { log 'processing'; sleep 1.0 }
      end.not_to raise_error

      expect(operator.result).to eq(true)
      expect(operator.duration).to be_within(0.1).of(1.0)
      expect(operator.error).to eq(nil)
      expect(operator.stream.out).to include('Are you sure to commit?')
      expect(operator.stream.out).to include('Finished successfully:')
      expect(operator.stream.out).to include('Total time:')
    end

    it 'confirm で no' do
      allow(STDIN).to receive(:gets) do
        "no\n"
      end

      expect do
        operator.execute { log 'processing'; sleep 1.0 }
      end.to raise_error(ActiveRecord::Rollback)

      expect(operator.result).to eq(false)
      expect(operator.duration).to be_within(0.1).of(1.0)
      expect(operator.error.class).to eq(ActiveRecord::Rollback)
      expect(operator.stream.out).to include('Are you sure to commit?')
      expect(operator.stream.out).to include('Canceled:')
      expect(operator.stream.out).to include('Total time:')
    end

    it '処理中に例外' do
      expect do
        operator.execute { raise ArgumentError }
      end.to raise_error(ArgumentError)

      expect(operator.result).to eq(false)
      expect(operator.error.class).to eq(ArgumentError)
      expect(operator.stream.out).not_to include('Are you sure to commit?')
      expect(operator.stream.out).not_to include('Canceled:')
      expect(operator.stream.out).to include('Total time:')
    end
  end

  describe '#find_each_with_progress' do
    it '進捗が表示される' do
      class Dekiru::DummyRecord
        def self.count
          10
        end

        def self.find_each
          (0...count).to_a.each do |num|
            yield(num)
          end
        end
      end

      allow(STDIN).to receive(:gets) do
        "yes\n"
      end

      sum = 0
      operator.execute do
        find_each_with_progress(Dekiru::DummyRecord, title: 'count up number') do |num|
          sum += num
        end
      end

      expect(sum).to eq(45)
      expect(operator.result).to eq(true)
      expect(operator.error).to eq(nil)
      expect(operator.stream.out).to include('Are you sure to commit?')
      expect(operator.stream.out).to include('count up number:')
      expect(operator.stream.out).to include('Finished successfully:')
      expect(operator.stream.out).to include('Total time:')
    end
  end
end
