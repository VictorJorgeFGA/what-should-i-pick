class Champion < ApplicationRecord
  has_many :champion_translations, dependent: :destroy, autosave: true
  accepts_nested_attributes_for :champion_translations

  validates :key, uniqueness: true

  def self.translatable_fields
    ChampionTranslation.column_names - %w[id locale champion_id created_at updated_at]
  end

  def translations
    champion_translations
  end

  include Translatable
end
