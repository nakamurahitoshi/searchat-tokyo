class Railway < ApplicationRecord
  has_many :stations, through: :stations_railways
  has_many :stations_railways
  validates :name, presence: true, uniqueness: true
end