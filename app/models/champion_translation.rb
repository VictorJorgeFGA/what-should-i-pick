class ChampionTranslation < ApplicationRecord
  belongs_to :champion

  validates :locale, uniqueness: true
end
