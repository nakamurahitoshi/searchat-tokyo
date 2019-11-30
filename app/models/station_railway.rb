class StationRailway < ApplicationRecord
  belongs_to :station
  belongs_to :railway
  validates :order, presence: true
end