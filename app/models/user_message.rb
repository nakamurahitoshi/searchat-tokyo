class UserMessage < ApplicationRecord
  has_many :users
  has_many :messages
  validates :is_gave, presence: true
end