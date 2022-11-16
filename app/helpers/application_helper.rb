module ApplicationHelper
  def flag_file_name_according_to_i18n
    case I18n.locale
    when :es
      'spain.png'
    when :'pt-BR'
      'brazil.png'
    else
      'united-kingdom.png'
    end
  end
end
