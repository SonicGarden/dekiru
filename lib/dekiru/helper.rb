module Dekiru
  module Helper
    def null_check_localization(object, **options)
      localize(object, **options) if object.present?
    end
    alias nl null_check_localization
  end
end
