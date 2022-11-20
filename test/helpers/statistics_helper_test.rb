require 'test_helper'

class StatisticsHelperTest < ActionView::TestCase
  test 'should return available regions correctly' do
    assert_equal %w[global na euw eune oce kr jp br las lan ru tr], available_regions
  end

  test 'should return available tiers correctly' do
    assert_equal %w[iron bronze silver gold platinum diamond master grandmaster challenger all], available_tiers
  end

  test 'should return availalbe positions correctly' do
    assert_equal %w[top jungle mid adc support all], available_positions
  end
end
