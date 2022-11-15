require 'test_helper'

class StatisticTest < ActiveSupport::TestCase
  test 'should not duplicate statistic' do
    champ = champions(:Aatrox)
    statistic = champ.statistics.create(
      {
        tier: 'iron',
        position: 'top',
        win_rate: 0.5,
        pick_rate: 0.1,
        period: 'week',
        region: 'global'
      }
    )
    assert statistic.persisted?

    statistic = champ.statistics.build(
      {
        tier: 'iron',
        position: 'top',
        win_rate: 0.5,
        pick_rate: 0.1,
        period: 'week',
        region: 'global'
      }
    )
    assert_not statistic.valid?
    assert_equal :taken, statistic.errors.details[:position].first[:error]
  end

  test 'should allow statistic creation for different tier, position, period, region, champion combinations' do
    champ = champions(:Aatrox)
    statistic = champ.statistics.create(
      {
        tier: 'iron',
        position: 'top',
        win_rate: 0.5,
        pick_rate: 0.1,
        period: 'week',
        region: 'global'
      }
    )
    assert statistic.persisted?

    statistic = champ.statistics.create(
      {
        tier: 'gold',
        position: 'top',
        win_rate: 0.5,
        pick_rate: 0.1,
        period: 'week',
        region: 'global'
      }
    )
    assert statistic.persisted?

    statistic = champ.statistics.create(
      {
        tier: 'gold',
        position: 'mid',
        win_rate: 0.5,
        pick_rate: 0.1,
        period: 'week',
        region: 'global'
      }
    )
    assert statistic.persisted?

    statistic = champ.statistics.create(
      {
        tier: 'gold',
        position: 'top',
        win_rate: 0.5,
        pick_rate: 0.1,
        period: 'day',
        region: 'global'
      }
    )
    assert statistic.persisted?

    statistic = champ.statistics.create(
      {
        tier: 'gold',
        position: 'top',
        win_rate: 0.5,
        pick_rate: 0.1,
        period: 'week',
        region: 'br'
      }
    )
    assert statistic.persisted?
  end

  test 'should require tier, position, win_rate, pick_rate, period, region and champion presence' do
    statistic = Statistic.new

    assert_not statistic.valid?
    assert_equal :blank, statistic.errors.details[:tier].first[:error]
    assert_equal :blank, statistic.errors.details[:position].first[:error]
    assert_equal :blank, statistic.errors.details[:win_rate].first[:error]
    assert_equal :blank, statistic.errors.details[:pick_rate].first[:error]
    assert_equal :blank, statistic.errors.details[:period].first[:error]
    assert_equal :blank, statistic.errors.details[:region].first[:error]
    assert_equal :blank, statistic.errors.details[:champion].first[:error]
  end

  test 'should update primary and secondary role with value from champion model' do
    champion = champions(:Aatrox)
    statistic = champion.statistics.create(
      {
        tier: 'iron',
        position: 'mid',
        win_rate: 0.504,
        pick_rate: 0.1247,
        period: 'week',
        region: 'na'
      }
    )
    assert_not champion.primary_role.blank?
    assert_not champion.secondary_role.blank?
    assert_equal champion.primary_role, statistic.primary_role
    assert_equal champion.secondary_role, statistic.secondary_role
  end

  test 'should update performance value whenver win_rate or pick_rate is updated' do
    champion = champions(:Aatrox)
    statistic = champion.statistics.create(
      {
        tier: 'gold',
        position: 'top',
        win_rate: 0.52,
        pick_rate: 0.1,
        period: 'day',
        region: 'global'
      }
    )

    expected_value = (0.52 - 0.5) * 0.1
    assert_equal expected_value, statistic.performance

    statistic.win_rate = 0.53
    expected_value = (0.53 - 0.5) * 0.1
    assert_equal expected_value, statistic.performance

    statistic.pick_rate = 0.2
    expected_value = (0.53 - 0.5) * 0.2
    assert_equal expected_value, statistic.performance
  end

  test 'should return the statistic with the highest win_rate and performance for a specific context' do
    champion = champions(:Aatrox)
    champion.statistics.create(
      {
        tier: 'gold',
        position: 'top',
        win_rate: 0.5271,
        pick_rate: 0.1342,
        period: 'day',
        region: 'global'
      }
    )
    champion.statistics.create(
      {
        tier: 'gold',
        position: 'top',
        win_rate: 0.5271,
        pick_rate: 0.9042,
        period: 'day',
        region: 'global'
      }
    )

    champion = champions(:Ahri)
    champion.statistics.create(
      {
        tier: 'gold',
        position: 'top',
        win_rate: 0.5141,
        pick_rate: 0.2663,
        period: 'day',
        region: 'global'
      }
    )
    champion.statistics.create(
      {
        tier: 'gold',
        position: 'top',
        win_rate: 0.9041,
        pick_rate: 0.2663,
        period: 'day',
        region: 'na'
      }
    )

    champion = champions(:Akali)
    champion.statistics.create(
      {
        tier: 'gold',
        position: 'top',
        win_rate: 0.4953,
        pick_rate: 0.2149,
        period: 'day',
        region: 'global'
      }
    )
    champion.statistics.create(
      {
        tier: 'gold',
        position: 'top',
        win_rate: 0.4953,
        pick_rate: 1.0,
        period: 'day',
        region: 'na'
      }
    )
    champion = champions(:Akshan)
    champion.statistics.create(
      {
        tier: 'gold',
        position: 'top',
        win_rate: 0.4979,
        pick_rate: 0.7049,
        period: 'day',
        region: 'global'
      }
    )
    champion.statistics.create(
      {
        tier: 'gold',
        position: 'top',
        win_rate: 0.4979,
        pick_rate: 0.001,
        period: 'day',
        region: 'na'
      }
    )
    assert_equal(
      'Aatrox',
      Statistic.with_highest_win_rate_for(
        role: ['mage', 'fighter', 'marksman', 'assassin'],
        tier: 'gold',
        position: 'top',
        period: 'day',
        region: 'global'
      ).first.champion.name
    )
    assert_equal(
      'Ahri',
      Statistic.with_highest_performance_for(
        role: ['mage', 'fighter', 'marksman', 'assassin'],
        tier: 'gold',
        position: 'top',
        period: 'day',
        region: 'global'
      ).first.champion.name
    )
    assert_equal(
      'Ahri',
      Statistic.with_highest_performance_for(
        role: ['assassin'],
        tier: 'gold',
        position: 'top',
        period: 'day',
        region: 'global'
      ).first.champion.name
    )
  end
end
