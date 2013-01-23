require "http_accept_language"

module Dekiru
  module ControllerAdditions
    def set_locale
      I18n.locale = locale_from_params || locale_from_header
      logger.info "[locale] #{I18n.locale}"
    end

    def locale_from_params
      (I18n.available_locales & [params[:locale].try(:to_sym)]).first
    end

    def locale_from_header
      logger.debug "[debug] #{http_accept_language.user_preferred_languages}"
      http_accept_language.compatible_language_from(I18n.available_locales)
    end
  end
end
