class Adventure < ApplicationRecord
  DURATIONS = [
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

  # 勝利判定
  def calculate_result(party_power)
    party_power >= dungeon.required_power
  end
end
