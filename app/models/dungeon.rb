class Dungeon < ApplicationRecord
  has_many :adventures, dependent: :destroy
  has_many :users, through: :adventures

  validates :name, presence: true
  validates :difficulty, presence: true, numericality: { greater_than: 0 }
  validates :reward_gold, presence: true, numericality: { greater_than: 0 }

  def enemy_power
    difficulty * 50
  end
end
