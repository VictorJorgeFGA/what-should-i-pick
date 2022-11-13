require 'active_support/concern'

module Translatable
  extend ActiveSupport::Concern

  included do
    translatable_fields.each do |field|
      define_method field do
        if I18n.locale == :en
          super()
        elsif (translation = translations.select { |t| t.locale.to_sym == I18n.locale }.first)
          translation.send(field)
        end
      end

      define_method :"#{field}=" do |value|
        if I18n.locale == :en
          super(value)
        elsif (translation = translations.select { |t| t.locale.to_sym == I18n.locale }.first)
          translation.send("#{field}=", value)
        else
          translation = translations.build(locale: I18n.locale)
          translation.send("#{field}=", value)
        end
      end
    end
  end
end
