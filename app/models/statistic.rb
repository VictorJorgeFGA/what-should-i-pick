class Statistic < ApplicationRecord
  belongs_to :champion

  validates :position, uniqueness: { scope: %i[tier period region champion_id] }
  validates :tier, :position, :win_rate, :pick_rate, :period, :region, presence: true

  before_save :update_roles

  enum(tier:
  {
    iron: 0,
    bronze: 1,
    silver: 2,
    gold: 3,
    platinum: 4,
    diamond: 5,
    master: 6,
    grandmaster: 7,
    challenger: 8,
    all: 9
  }, _suffix: true)

  enum(position:
  {
    top: 0,
    jungle: 1,
    mid: 2,
    adc: 3,
    support: 4
  }, _prefix: true)

  enum(period:
  {
    month: 0,
    week: 1,
    day: 2
  }, _prefix: true)

  enum(region:
  {
    global: 0,
    na: 1,
    euw: 2,
    eune: 3,
    oce: 4,
    kr: 5,
    jp: 6,
    br: 7,
    las: 8,
    lan: 9,
    ru: 10,
    tr: 11
  }, _prefix: true)

  scope :with_highest_win_rate_for, ->(role:, tier:, position:, period:, region:) {
    includes(:champion)
      .where(tier:, position:, period:, region:)
      .and(where(primary_role: role).or(where(secondary_role: role)))
      .order(win_rate: :desc)
  }

  scope :with_highest_performance_for, ->(role:, tier:, position:, period:, region:) {
    includes(:champion)
      .where(tier:, position:, period:, region:)
      .and(where(primary_role: role).or(where(secondary_role: role)))
      .order(performance: :desc, pick_rate: :desc)
  }

  def update_performance_value
    self.performance = (win_rate.to_f - 0.5) * pick_rate.to_f
  end

  def update_roles
    return unless champion

    self.primary_role = champion.primary_role
    self.secondary_role = champion.secondary_role
  end

  def win_rate=(value)
    super(value)
    update_performance_value
  end

  def pick_rate=(value)
    super(value)
    update_performance_value
  end
end
