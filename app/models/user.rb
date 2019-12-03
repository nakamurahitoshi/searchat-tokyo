class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :messages
  belongs_to :station, optional: true
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :point, presence: true
end