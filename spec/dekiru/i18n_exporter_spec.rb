require "spec_helper"

describe Dekiru::I18nExporter do
  before do
    I18n.backend.store_translations :ja, {
      text: {
        hello: 'こんにちは',
        dekiru: '出来る',
      },
      errors: {
        messages: {
          invalid: '不正な値です',
        },
      },
    }
  end

  describe '#to_hash' do
    subject { Dekiru::I18nExporter.new(prefixes, locale).to_hash }

    context '一つのprefixを指定' do
      let(:prefixes) { :text }
      let(:locale) { :ja }

      it { is_expected.to eq({ text: { dekiru: '出来る', hello: 'こんにちは' } }) }
    end

    context '複数のprefixを指定' do
      let(:prefixes) { %w[text errors.messages] }
      let(:locale) { :ja }

      it { is_expected.to eq({ text: { dekiru: '出来る', hello: 'こんにちは' }, errors: { messages: { invalid: '不正な値です' } } }) }
    end
  end

  describe '#to_json' do
    subject { Dekiru::I18nExporter.new(prefixes, locale).to_json }

    context '一つのprefixを指定' do
      let(:prefixes) { :text }
      let(:locale) { :ja }

      it { is_expected.to eq "{\"text\":{\"hello\":\"こんにちは\",\"dekiru\":\"出来る\"}}" }
    end

    context '複数のprefixを指定' do
      let(:prefixes) { %w[text errors.messages] }
      let(:locale) { :ja }

      it { is_expected.to eq "{\"text\":{\"hello\":\"こんにちは\",\"dekiru\":\"出来る\"},\"errors\":{\"messages\":{\"invalid\":\"不正な値です\"}}}" }
    end
  end
end
