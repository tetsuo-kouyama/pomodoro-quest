class OwnedMonster < ApplicationRecord
  before_validation :set_default_nickname
  before_destroy :ensure_not_last_monster

  has_many :adventure_members, dependent: :destroy
  has_many :adventures, through: :adventure_members
  belongs_to :user
  belongs_to :monster

  validates :nickname, length: { maximum: 20 }, allow_blank: true
  validates :party_position, uniqueness: { scope: :user_id }, allow_nil: true

  MAX_PARTY_SIZE = 5

  scope :active, -> { where(active: true) }
  scope :inactive, -> { where(active: false) }

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

  def locked_for_adventure?
    user.adventuring? && active?
  end

  def only_monster?
    user.owned_monsters.count <= 1
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

  def ensure_not_last_monster
    return unless only_monster?

    errors.add(:base, "最後のモンスターは解雇できません")
    throw(:abort)
  end
end
