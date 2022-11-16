class ApplicationController < ActionController::Base
  around_action :switch_locale_context

  def switch_locale_context(&)
    locale = cookies[:user_lang] || I18n.default_locale
    I18n.with_locale(locale, &)
  end

  def home
  end

  def change_user_language
    user_lang = params[:user_lang].to_sym
    cookies.permanent[:user_lang] = user_lang if user_lang.in?(I18n.available_locales)
    render plain: 'ok'
  end
end
