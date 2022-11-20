class Champion < ApplicationRecord
  has_many :champion_translations, dependent: :destroy, autosave: true
  accepts_nested_attributes_for :champion_translations

  has_many :statistics, dependent: :destroy

  validates :key, uniqueness: true

  attr_accessor :most_relevant_statistic

  delegate :win_rate, :pick_rate, :performance, to: :most_relevant_statistic

  def self.translatable_fields
    ChampionTranslation.column_names - %w[id locale champion_id created_at updated_at]
  end

  def translations
    champion_translations
  end

  include Translatable

  def self.all_champions
    Rails.cache.fetch("#{Time.zone.today.to_fs(:iso8601)}/all_champions", expires_in: 12.hours) do
      Champion.all
    end
  end

  def self.most_relevant_statistic_for(champion, tier:, region:, position:)
    Rails.cache.fetch("#{Time.zone.today.to_fs(:iso8601)}/#{champion.key}/#{tier}/#{region}/#{position}", expires_in: 12.hours) do
      champion.statistics.where(tier:, region:, position: position == 'all' ? Statistic.positions.keys : position).order(pick_rate: :desc).first
    end
  end

  def self.all_champions_filtered_by(tier:, region:, position:)
    Champion.all_champions.select do |champion|
      champion.most_relevant_statistic = Champion.most_relevant_statistic_for(champion, tier:, region:, position:)
      champion.most_relevant_statistic.present?
    end
  end

  def self.sort_champions_array_by(champions, field:, sort_type:)
    champions = champions.sort do |c1, c2|
      c1.send(field) <=> c2.send(field)
    end
    if sort_type.to_s == 'asc'
      champions
    else
      champions.reverse
    end
  end
end
