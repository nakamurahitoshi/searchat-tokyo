class Message < ApplicationRecord
  belongs_to :user
  belongs_to :station
  validates :body, presence: true
end