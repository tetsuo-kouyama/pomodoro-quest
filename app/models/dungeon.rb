class Dungeon < ApplicationRecord
  has_many :adventures, dependent: :destroy
  has_many :users, through: :adventures

  validates :name, presence: true
  validates :required_time, presence: true
  validates :difficulty, presence: true
  validates :reward_gold, presence: true
end
