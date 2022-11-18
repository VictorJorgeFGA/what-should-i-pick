module ChampionsHelper
  def performance_badge_class_for(statistic)
    if statistic.win_rate >= 0.52
      'primary'
    elsif statistic.win_rate >= 0.505
      'success'
    elsif statistic.win_rate >= 0.495
      'warning'
    else
      'danger'
    end
  end

  def performance_badge_text_for(statistic)
    if statistic.win_rate >= 0.52
      I18n.t('statistic.label.outstanding')
    elsif statistic.win_rate >= 0.505
      I18n.t('statistic.label.good')
    elsif statistic.win_rate >= 0.495
      I18n.t('statistic.label.ok')
    else
      I18n.t('statistic.label.poor')
    end
  end
end
