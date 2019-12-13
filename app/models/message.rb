class Message < ApplicationRecord
  belongs_to :user
  belongs_to :station
  has_many :users, through: :user_messages
  validates :body, presence: true
end