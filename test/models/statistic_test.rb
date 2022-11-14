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
end
