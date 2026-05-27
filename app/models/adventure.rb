class Adventure < ApplicationRecord
  DURATIONS = [
    [ "test", 0.1.minutes ],
    [ "25分", 25.minutes ],
    [ "60分", 60.minutes ],
    [ "90分", 90.minutes ]
  ].freeze

  DURATION_VALUES = DURATIONS.map(&:last).freeze

  has_many :adventure_members, dependent: :destroy
  has_many :owned_monsters, through: :adventure_members
  belongs_to :user
  belongs_to :dungeon

  validates :required_time, inclusion: { in: DURATION_VALUES }
  validates :reward_gold, numericality: { greater_than: 0 }

  enum :status, {
    pending: 0,   # 出発前
    ongoing: 1,   # 冒険中
    finished: 2,  # 帰還済み
    claimed: 3    # 報酬受取済み
  }

  scope :latest_active, -> {
    where(status: %i[ongoing finished])
      .order(start_at: :desc)
  }

  # 残り時間を計算
  def remaining_seconds
    [ end_at - Time.current, 0 ].max
  end

  # 冒険が完了しているかを判定
  def check_completion!
    if ongoing? && Time.current >= end_at
      finished!
    end
  end

  # パーティの合計ステータス計算
  def total_party_power
    adventure_members.includes(owned_monster: :monster).sum do |member|
      monster = member.owned_monster
      monster.hp + monster.atk + monster.def
    end
  end

  # クリアに必要な条件
  def enemy_power
    dungeon.difficulty * 100
  end

  # 勝利判定
  def combat_victory?
    total_party_power >= enemy_power
  end

  # 冒険に出発させるパーティメンバーと冒険データを紐付ける
  def assign_members(monsters)
    monsters.each do |monster|
      adventure_members.build(
        owned_monster_id: monster.id,
        slot: monster.party_position
      )
    end
  end

  # Adventure生成の初期化処理
  def prepare_for_departure!
    self.start_at = Time.current
    self.end_at = start_at + required_time.to_i
    self.reward_gold = dungeon.reward_gold
    self.status = :ongoing
  end

  # 冒険後の報酬決定
  def resolve_combat
    if combat_victory?
      { victory: true, reward: reward_gold }
    else
      { victory: false, reward: (reward_gold * 0.1).to_i }
    end
  end
end
