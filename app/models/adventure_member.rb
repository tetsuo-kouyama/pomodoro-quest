class AdventureMember < ApplicationRecord
  belongs_to :owned_monster
  belongs_to :adventure

  validates :slot, inclusion: { in: 1..OwnedMonster::MAX_PARTY_SIZE }
end
