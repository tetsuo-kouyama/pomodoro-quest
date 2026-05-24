class OwnedMonster < ApplicationRecord
  before_validation :set_default_nickname

  belongs_to :user
  belongs_to :monster

  validates :nickname, length: { maximum: 20 }, allow_blank: true

  def hp
    monster.base_hp + (level - 1) * hp_growth
  end

  def atk
    monster.base_atk + (level - 1) * atk_growth
  end

  def def
    monster.base_def + (level - 1) * def_growth
  end

  def increment_level!(user)
    raise InsufficientGoldError if user.gold < next_level_cost
    transaction do
      user.decrement!(:gold, next_level_cost)
      increment!(:level)
    end
  end

  def next_level_cost
    (level + 1) * monster.hire_cost
  end

  private

  def set_default_nickname
    self.nickname = monster.name if nickname.blank?
  end

  def hp_growth
    10
  end

  def atk_growth
    5
  end

  def def_growth
    5
  end
end
