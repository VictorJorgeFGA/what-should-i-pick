require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  test 'should return flag name according to i18n correctly' do
    I18n.with_locale(:es) do
      assert_equal 'spain.png', flag_file_name_according_to_i18n
    end
    I18n.with_locale(:'pt-BR') do
      assert_equal 'brazil.png', flag_file_name_according_to_i18n
    end
    I18n.with_locale(:en) do
      assert_equal 'united-kingdom.png', flag_file_name_according_to_i18n
    end
  end
end
