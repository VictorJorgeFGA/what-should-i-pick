module StatisticsHelper
  def available_regions
    Statistic.regions.keys
  end

  def available_tiers
    Statistic.tiers.keys
  end

  def available_positions
    Statistic.positions.keys + ['all']
  end

  def translated_region(region)
    I18n.t("regions.#{region}")
  end

  def translated_tier(tier)
    I18n.t("tiers.#{tier}")
  end

  def translated_position(position)
    I18n.t("positions.#{position}")
  end

  def winrate_badge_class_for(win_rate)
    win_rate *= 100.0
    if win_rate >= 54.0
      'blue-500'
    elsif win_rate >= 52.5
      'indigo-500'
    elsif win_rate >= 51.5
      'teal-500'
    elsif win_rate >= 50.5
      'green-500'
    elsif win_rate >= 49.5
      'yellow-600'
    elsif win_rate >= 47.0
      'orange-600'
    elsif win_rate >= 40.0
      'red-600'
    elsif win_rate >= 30.0
      'red-700'
    else
      'red-800'
    end
  end

  def winrate_badge_text_for(win_rate)
    win_rate *= 100.0
    if win_rate >= 54.0
      I18n.t('statistic.label.winrate.legendary')
    elsif win_rate >= 52.5
      I18n.t('statistic.label.winrate.outstanding')
    elsif win_rate >= 51.5
      I18n.t('statistic.label.winrate.very_good')
    elsif win_rate >= 50.5
      I18n.t('statistic.label.winrate.good')
    elsif win_rate >= 49.5
      I18n.t('statistic.label.winrate.ok')
    elsif win_rate >= 47.0
      I18n.t('statistic.label.winrate.below_average')
    elsif win_rate >= 40.0
      I18n.t('statistic.label.winrate.poor')
    elsif win_rate >= 30.0
      I18n.t('statistic.label.winrate.terrible')
    else
      I18n.t('statistic.label.winrate.garbage')
    end
  end

  def pickrate_badge_class_for(pick_rate)
    pick_rate *= 100.0
    if pick_rate >= 15.0
      'blue-500'
    elsif pick_rate >= 12.0
      'indigo-500'
    elsif pick_rate >= 9.0
      'teal-500'
    elsif pick_rate >= 6
      'green-600'
    elsif pick_rate >= 2.75
      'yellow-600'
    elsif pick_rate >= 1.2
      'orange-600'
    elsif pick_rate >= 0.8
      'red-500'
    elsif pick_rate >= 0.6
      'red-600'
    elsif pick_rate >= 0.35
      'red-800'
    else
      'purple-500'
    end
  end

  def pickrate_badge_text_for(pick_rate)
    pick_rate *= 100.0
    if pick_rate >= 15.0
      I18n.t('statistic.label.pickrate.fever')
    elsif pick_rate >= 12.0
      I18n.t('statistic.label.pickrate.super_popular')
    elsif pick_rate >= 9.0
      I18n.t('statistic.label.pickrate.popular')
    elsif pick_rate >= 6
      I18n.t('statistic.label.pickrate.frequent')
    elsif pick_rate >= 2.75
      I18n.t('statistic.label.pickrate.common')
    elsif pick_rate >= 1.2
      I18n.t('statistic.label.pickrate.sporadic')
    elsif pick_rate >= 0.8
      I18n.t('statistic.label.pickrate.forgotten')
    elsif pick_rate >= 0.6
      I18n.t('statistic.label.pickrate.rare')
    elsif pick_rate >= 0.35
      I18n.t('statistic.label.pickrate.very_rare')
    else
      I18n.t('statistic.label.pickrate.odd')
    end
  end
end
