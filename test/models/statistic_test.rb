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

    expected_value = (0.52 - 0.5) * 0.1 * 1000.0
    assert_equal expected_value, statistic.performance

    statistic.win_rate = 0.53
    expected_value = (0.53 - 0.5) * 0.1 * 1000.0
    assert_equal expected_value, statistic.performance

    statistic.pick_rate = 0.2
    expected_value = (0.53 - 0.5) * 0.2 * 1000.0
    assert_equal expected_value, statistic.performance
  end

  test 'should valid tiers correctly' do
    valid = ['iron', :bronze, 'silver', :gold, 'platinum', 'diamond', 'master', 'grandmaster', 'challenger', 'all']
    invalid = ['hey', 1, nil, :invalid_tier]

    valid.each do |tier|
      assert Statistic.a_valid_tier?(tier), tier
    end
    invalid.each do |tier|
      assert_not Statistic.a_valid_tier?(tier), tier
    end
  end

  test 'should valid positions correctly' do
    valid = ['top', :jungle, 'mid', 'adc', :support]
    invalid = ['Top', 1, nil, :invalid_tier]

    valid.each do |position|
      assert Statistic.a_valid_position?(position), position
    end

    invalid.each do |position|
      assert_not Statistic.a_valid_position?(position), position
    end
  end

  test 'should valid regions correctly' do
    valid = %w[global na euw eune oce kr jp br las lan ru tr] + %i[global na euw eune oce kr jp br las lan ru tr]
    invalid = ['amdasod', 'opa', 1, false, nil]

    valid.each do |region|
      assert Statistic.a_valid_region?(region), region
    end

    invalid.each do |region|
      assert_not Statistic.a_valid_region?(region), region
    end
  end
end
