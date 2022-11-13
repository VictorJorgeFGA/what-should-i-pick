class Champion < ApplicationRecord
  validates :key, uniqueness: true
end
