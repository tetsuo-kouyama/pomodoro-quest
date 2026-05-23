class OwnedMonster < ApplicationRecord
  before_validation :set_default_nickname

  belongs_to :user
  belongs_to :monster

  validates :nickname, length: { maximum: 20 }, allow_blank: true

  private

  def set_default_nickname
    self.nickname = monster.name if nickname.blank?
  end
end
