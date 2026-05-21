class User < ApplicationRecord
  has_secure_password

  has_many :owned_monsters, dependent: :destroy
  has_many :monsters, through: :owned_monsters

  validates :name, presence: true, length: { maximum: 20 }
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, length: { minimum: 6 }, confirmation: true, allow_nil: true
  validates :gold, numericality: { greater_than_or_equal_to: 0 }
end
