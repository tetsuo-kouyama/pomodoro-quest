class Monster < ApplicationRecord
  has_many :owned_monsters, dependent: :destroy
  has_many :users, through: :owned_monsters

  validates :name, presence: true
  validates :base_hp, :base_atk, :base_def, :hire_cost, numericality: { greater_than_or_equal_to: 0 }
end
