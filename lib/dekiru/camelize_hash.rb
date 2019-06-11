module Dekiru
  module CamelizeHash
    refine ::Hash do
      def camelize_keys(first_letter = :upper)
        transform_keys do |k|
          if k.is_a?(Symbol)
            k.to_s.camelize(first_letter).to_sym
          else
            k.camelize(first_letter)
          end
        end
      end

      def deep_camelize_keys(first_letter = :upper)
        deep_transform_keys do |k|
          if k.is_a?(Symbol)
            k.to_s.camelize(first_letter).to_sym
          else
            k.camelize(first_letter)
          end
        end
      end
    end
  end
end
