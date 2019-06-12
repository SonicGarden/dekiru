require "spec_helper"

describe Dekiru::CamelizeHash do
  using Dekiru::CamelizeHash

  let(:hash) do
    hash = {
      dekiru_rails: {
         dekiru_rails: 'dekiru'
      },
      'dekiru_ruby' => {
        'dekiru_ruby' => 'dekiru'
      }
    }
  end

  describe '#camelize_keys' do
    it '一階層目のキーがキャメルケースに変換される' do
      expect(hash.camelize_keys(:lower)).to match({
        dekiruRails: {
           dekiru_rails: 'dekiru'
        },
        'dekiruRuby' => {
          'dekiru_ruby' => 'dekiru'
        }
      })
    end

    it '一階層目のキーがアッパーキャメルケースに変換される' do
      expect(hash.camelize_keys).to match({
        DekiruRails: {
           dekiru_rails: 'dekiru'
        },
        'DekiruRuby' => {
          'dekiru_ruby' => 'dekiru'
        }
      })
    end
  end

  describe '#deep_camelize_keys' do
    it '2階層目以降のキーもキャメルケースに変換される' do
      expect(hash.deep_camelize_keys(:lower)).to match({
        dekiruRails: {
           dekiruRails: 'dekiru'
        },
        'dekiruRuby' => {
          'dekiruRuby' => 'dekiru'
        }
      })
    end

    it '2階層目以降のキーもアッパーキャメルケースに変換される' do
      expect(hash.deep_camelize_keys).to match({
        DekiruRails: {
           DekiruRails: 'dekiru'
        },
        'DekiruRuby' => {
          'DekiruRuby' => 'dekiru'
        }
      })
    end
  end
end
