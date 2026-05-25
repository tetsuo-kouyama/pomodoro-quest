class Adventure < ApplicationRecord
  DURATIONS = [
    25.minutes,
    60.minutes,
    90.minutes
  ].freeze

  belongs_to :user
  belongs_to :dungeon

  validates :required_time, inclusion: { in: DURATIONS }
  validates :reward_gold, numericality: { greater_than: 0 }

  enum :status, {
    preparing: 0,
    ongoing: 1,
    completed: 2
  }

  def remaining_seconds
    [ end_at - Time.current, 0 ].max
  end
end
