class ChampionTranslation < ApplicationRecord
  belongs_to :champion

  validates :locale, uniqueness: { scope: :champion_id }
end
