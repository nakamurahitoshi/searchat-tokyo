class Railway < ApplicationRecord
  has_many :station_railways
  has_many :stations, through: :station_railways
  validates :name, presence: true
  validates :odptrailway, presence: true, uniqueness: true
end