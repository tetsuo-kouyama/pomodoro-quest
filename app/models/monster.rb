class Monster < ApplicationRecord
  validates :name, presence: true
  validates :base_hp, :base_atk, :base_def, :hire_cost, numericality: { greater_than_or_equal_to: 0 }
end
