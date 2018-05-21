require 'spec_helper'

describe ActiveModel::Validations::ExistenceValidator do
  let(:user_class) do
    Class.new do
      def self.exists?(id)
        %w[valid_id].member?(id)
      end
    end
  end
  let(:model_class) do
    _options = options

    Struct.new(:user_id, :users) do
      include ActiveModel::Validations

      def self.name
        'DummyModel'
      end

      validates :user_id, existence: _options
    end
  end

  describe 'validate' do
    subject(:valid?) do
      model_class.new(user_id, user_class).valid?
    end

    context 'with exists id' do
      let(:user_id) { 'valid_id' }
      let(:options) { { in: -> { users } } }

      it { is_expected.to eq true }
    end

    context 'with exists not id' do
      let(:user_id) { 'invalid_id' }
      let(:options) { { in: -> { users } } }

      it { is_expected.to eq false }
    end

    context 'with invalid option' do
      let(:user_id) { 'valid_id' }
      let(:options) { { in: user_class } }

      it { expect { valid? }.to raise_error(ArgumentError) }
    end
  end
end
