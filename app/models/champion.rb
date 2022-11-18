class Champion < ApplicationRecord
  has_many :champion_translations, dependent: :destroy, autosave: true
  accepts_nested_attributes_for :champion_translations

  has_many :statistics, dependent: :destroy

  validates :key, uniqueness: true

  def self.translatable_fields
    ChampionTranslation.column_names - %w[id locale champion_id created_at updated_at]
  end

  def translations
    champion_translations
  end

  include Translatable

  def best_win_rate_statistic
    @best_win_rate_stat ||=
    statistics.sort do |a, b|
      if a.win_rate < b.win_rate
        -1
      elsif a.win_rate == b.win_rate
        0
      else
        1
      end
    end.last
  end

  def best_performance_statistic
    @best_win_rate_stat ||=
    statistics.sort do |a, b|
      if a.performance < b.performance
        -1
      elsif a.performance == b.performance
        0
      else
        1
      end
    end.last
  end

  def most_frequent_statistic_for(tier:)
    instance_variable_name = "@most_frequent_statistic_for_#{tier.to_s}"
    if instance_variable_defined?(instance_variable_name)
      instance_variable_get(instance_variable_name)
    else
      stats = statistics.select do |stat|
        stat.tier.to_s == tier.to_s
      end

      stats = stats.sort do |a, b|
        if a.pick_rate < b.pick_rate
          -1
        elsif a.pick_rate == b.pick_rate
          0
        else
          1
        end
      end
      instance_variable_set(instance_variable_name, stats.last)
    end
  end
end
