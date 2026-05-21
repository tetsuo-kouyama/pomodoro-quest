class OwnedMonster < ApplicationRecord
  belongs_to :user
  belongs_to :monster

  validates :nickname, length: { maximum: 20 }, allow_blank: true
end
