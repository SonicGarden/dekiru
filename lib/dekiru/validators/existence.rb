#   class Post < ActiveRecord::Base
#     belongs_to :company
#     belongs_to :user
#     validates :user_id, presence: true, existence: { in: -> { company.users } }
#   end

module ActiveModel
  module Validations
    class ExistenceValidator < EachValidator
      def validate_each(record, attribute, value)
        unless exists?(record, value)
          record.errors.add(attribute, :existence, **options.except(:in).merge!(value: value))
        end
      end

      def exists?(record, value)
        unless options[:in].respond_to?(:call)
          raise ArgumentError, '`in` option should be proc'
        end
        collection = record.instance_exec(&options[:in])
        collection.exists?(value)
      end
    end
  end
end
