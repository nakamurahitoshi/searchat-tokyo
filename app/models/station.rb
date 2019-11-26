class Station < ApplicationRecord
  has_many :users
  has_many :railways, through: :stations_railways
  has_many :stations_railways
  validates :name, presence: true, uniqueness: true
  validates :lat, presence: true, uniqueness: true
  validates :lng, presence: true, uniqueness: true
end
