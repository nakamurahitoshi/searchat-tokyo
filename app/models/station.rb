class Station < ApplicationRecord
  has_many :users
  has_many :station_railways
  has_many :railways, through: :station_railways
  has_many :messages
  validates :name, presence: true, uniqueness: true
  validates :lat, presence: true
  validates :lng, presence: true
end