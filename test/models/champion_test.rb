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

  test 'should filter champions correctly' do
    aatrox = champions(:Aatrox)
    stat1 = aatrox.statistics.create(
      {
        tier: 'bronze',
        position: 'top',
        win_rate: 0.55,
        pick_rate: 0.77,
        primary_role: 'fighter',
        secondary_role: 'tank',
        region: 'br',
        period: 'month'
      }
    )
    stat2 = aatrox.statistics.create(
      {
        tier: 'silver',
        position: 'top',
        win_rate: 0.55,
        pick_rate: 0.77,
        primary_role: 'fighter',
        secondary_role: 'tank',
        region: 'br',
        period: 'month'
      }
    )
    stat3 = aatrox.statistics.create(
      {
        tier: 'bronze',
        position: 'top',
        win_rate: 0.55,
        pick_rate: 0.77,
        primary_role: 'fighter',
        secondary_role: 'tank',
        region: 'global',
        period: 'month'
      }
    )
    aatrox.statistics.create(
      {
        tier: 'bronze',
        position: 'mid',
        win_rate: 0.70,
        pick_rate: 0.01,
        primary_role: 'fighter',
        secondary_role: 'tank',
        region: 'br',
        period: 'month'
      }
    )

    all_champions = Champion.all_champions_filtered_by(tier: 'bronze', position: 'top', region: 'br')
    filtered_champion = all_champions.first

    assert_equal [aatrox], all_champions
    assert_equal stat1, filtered_champion.most_relevant_statistic

    all_champions = Champion.all_champions_filtered_by(tier: 'bronze', position: 'all', region: 'br')
    filtered_champion = all_champions.first

    assert_equal [aatrox], all_champions
    assert_equal stat1, filtered_champion.most_relevant_statistic

    all_champions = Champion.all_champions_filtered_by(tier: 'silver', position: 'top', region: 'br')
    filtered_champion = all_champions.first

    assert_equal [aatrox], all_champions
    assert_equal stat2, filtered_champion.most_relevant_statistic

    all_champions = Champion.all_champions_filtered_by(tier: 'bronze', position: 'top', region: 'global')
    filtered_champion = all_champions.first

    assert_equal [aatrox], all_champions
    assert_equal stat3, filtered_champion.most_relevant_statistic
  end

  test 'should sort sort champions correctly' do
    aatrox = champions(:Aatrox)
    aatrox.statistics.create(
      {
        tier: 'bronze',
        position: 'top',
        win_rate: 0.55,
        pick_rate: 0.4,
        primary_role: 'fighter',
        secondary_role: 'tank',
        region: 'br',
        period: 'month'
      }
    )
    aatrox.most_relevant_statistic = aatrox.statistics.first

    ahri = champions(:Ahri)
    ahri.statistics.create(
      {
        tier: 'bronze',
        position: 'top',
        win_rate: 0.56,
        pick_rate: 0.3,
        primary_role: 'mage',
        secondary_role: 'assassin',
        region: 'br',
        period: 'month'
      }
    )
    ahri.most_relevant_statistic = ahri.statistics.first

    akali = champions(:Akali)
    akali.statistics.create(
      {
        tier: 'bronze',
        position: 'top',
        win_rate: 0.57,
        pick_rate: 0.2,
        primary_role: 'assassin',
        secondary_role: 'mage',
        region: 'br',
        period: 'month'
      }
    )
    akali.most_relevant_statistic = akali.statistics.first

    assert_equal(
      [aatrox, ahri, akali],
      Champion.sort_champions_array_by([aatrox, ahri, akali], field: 'win_rate', sort_type: 'asc'),
      'win_rate asc'
    )
    assert_equal(
      [akali, ahri, aatrox],
      Champion.sort_champions_array_by([akali, ahri, aatrox], field: 'win_rate', sort_type: 'desc'),
      'win_rate desc'
    )
    assert_equal(
      [aatrox, ahri, akali],
      Champion.sort_champions_array_by([aatrox, ahri, akali], field: 'name_id', sort_type: 'asc'),
      'name_id asc'
    )
    assert_equal(
      [akali, ahri, aatrox],
      Champion.sort_champions_array_by([akali, ahri, aatrox], field: 'name_id', sort_type: 'desc'),
      'name_id desc'
    )

    assert_equal(
      [akali, ahri, aatrox],
      Champion.sort_champions_array_by([aatrox, ahri, akali], field: 'pick_rate', sort_type: 'asc'),
      'pick_rate asc'
    )
    assert_equal(
      [aatrox, ahri, akali],
      Champion.sort_champions_array_by([akali, ahri, aatrox], field: 'pick_rate', sort_type: 'desc'),
      'pick_rate desc'
    )
  end
end
