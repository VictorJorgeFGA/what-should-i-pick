require 'test_helper'

class ChampionTest < ActiveSupport::TestCase
  test 'should not allow duplicating champions by riot key' do
    Champion.create!({ key: 123 })

    champ = Champion.new(key: 123)

    assert_not champ.valid?
    assert_equal :taken, champ.errors.details[:key].first[:error]
  end

  test 'should destroy all translations when champion is destroyed' do
    champion = Champion.create!({ key: 123 })
    champion.champion_translations.create!({ locale: :en })
    champion.champion_translations.create!({ locale: :'pt-BR' })

    t1 = champion.champion_translations.first
    t2 = champion.champion_translations.second

    assert ChampionTranslation.find_by(id: t1.id)
    assert ChampionTranslation.find_by(id: t2.id)

    champion.destroy!

    assert_nil ChampionTranslation.find_by(id: t1.id)
    assert_nil ChampionTranslation.find_by(id: t2.id)
  end

  test 'should translate translatable fields correctly' do
    champion = Champion.create!(
      {
        name: 'Aatrox',
        key: '1',
        title: 'Eng version',
        lore: 'This is the complete Aatrox lore',
        blurb: 'This is the Aatrox blurb',
        enemy_tips: 'You should do A. You should do B. You must avoid C',
        ally_tips: 'You should do A. You should do B. You must avoid C'
      }
    )

    I18n.with_locale(:'pt-BR') do
      champion.title = 'Versao pt-BR'
      champion.lore = 'Essa e a versao completa da historia do Aatrox'
      champion.blurb = 'Essa e a sinopse do Aatrox'
      champion.enemy_tips = 'Voce deve fazer A. Voce deve fazer B. Voce deve evitar C'
      champion.ally_tips = 'Voce deve fazer A. Voce deve fazer B. Voce deve evitar C'
      champion.save!
    end

    I18n.with_locale(:es) do
      champion.title = 'Versión en español'
      champion.lore = 'Esta es la historia completa de Aatrox'
      champion.blurb = 'Esta es la propaganda de Aatrox'
      champion.enemy_tips = 'Debes hacer A. Debes hacer B. Debes evitar C'
      champion.ally_tips = 'Debes hacer A. Debes hacer B. Debes evitar C'
      champion.save!
    end

    champion.reload

    I18n.with_locale(:en) do
      assert_equal 'Eng version', champion.title
      assert_equal 'This is the complete Aatrox lore', champion.lore
      assert_equal 'This is the Aatrox blurb', champion.blurb
      assert_equal 'You should do A. You should do B. You must avoid C', champion.enemy_tips
      assert_equal 'You should do A. You should do B. You must avoid C', champion.ally_tips

      champion.title = 'New title'
      champion.save!
      assert_equal 'New title', champion.title
    end

    I18n.with_locale(:'pt-BR') do
      assert_equal 'Versao pt-BR', champion.title
      assert_equal 'Essa e a versao completa da historia do Aatrox', champion.lore
      assert_equal 'Essa e a sinopse do Aatrox', champion.blurb
      assert_equal 'Voce deve fazer A. Voce deve fazer B. Voce deve evitar C', champion.enemy_tips
      assert_equal 'Voce deve fazer A. Voce deve fazer B. Voce deve evitar C', champion.ally_tips

      champion.title = 'Novo titulo'
      champion.save!
      assert_equal 'Novo titulo', champion.title
    end

    I18n.with_locale(:es) do
      assert_equal 'Versión en español', champion.title
      assert_equal 'Esta es la historia completa de Aatrox', champion.lore
      assert_equal 'Esta es la propaganda de Aatrox', champion.blurb
      assert_equal 'Debes hacer A. Debes hacer B. Debes evitar C', champion.enemy_tips
      assert_equal 'Debes hacer A. Debes hacer B. Debes evitar C', champion.ally_tips

      champion.title = 'Nuevo titulo'
      champion.save!
      assert_equal 'Nuevo titulo', champion.title
    end
  end
end
