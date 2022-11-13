require 'test_helper'

class ChampionTranslationTest < ActiveSupport::TestCase
  test 'should not allow two champions translations for the same locale' do
    champion = Champion.create(key: 123)
    ChampionTranslation.create!(locale: :en, champion:)
    translation = ChampionTranslation.new(locale: :en, champion:)

    assert_not translation.valid?
    assert_equal :taken, translation.errors.details[:locale].first[:error]
  end
end
