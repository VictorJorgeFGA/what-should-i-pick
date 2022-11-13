require 'test_helper'

class ChampionTest < ActiveSupport::TestCase
  test 'should not allow duplicating champions by riot key' do
    Champion.create!({ key: 123 })

    champ = Champion.new(key: 123)

    assert_not champ.valid?
    assert_equal :taken, champ.errors.details[:key].first[:error]
  end
end
