module Dekiru
  class I18nExporter
    def initialize(prefixes, locale = I18n.locale)
      @prefixes = Array(prefixes).map(&:to_s)
      @locale = locale
    end

    def to_hash
      hash = {}
      @prefixes.map do |prefix|
        res = I18n.exists?(prefix, locale: @locale) ? I18n.t(prefix, locale: @locale) : {}
        # NOTE: prefixがerrors.messages という場合、{ errors: { messages: res } } というハッシュを作る
        _hash = prefix.split('.').reverse.inject(res) { |memo, key| { key.to_sym => memo } }
        hash.deep_merge!(_hash)
      end
      hash
    end

    def to_json
      to_hash.to_json
    end
  end
end
