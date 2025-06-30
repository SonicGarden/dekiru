module Dekiru
  module Helper
    def null_check_localization(object, **options)
      Dekiru.deprecator.warn('nl helper is deprecated. Use l(object, default: nil) instead.')

      localize(object, **options) if object.present?
    end
    alias nl null_check_localization
  end
end
