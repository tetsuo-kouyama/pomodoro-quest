class PartiesController < ApplicationController
  before_action :ensure_not_adventuring, only: %i[ edit add_monster remove_monster ]
  before_action :load_party_data, only: %i[ edit add_monster remove_monster]
  before_action :set_owned_monster, only: %i[ add_monster remove_monster ]

  def edit; end

  def add_monster
    if @active_monsters.size >= OwnedMonster::MAX_PARTY_SIZE
      flash.now[:alert] = "これ以上編成できません"
      return
    end

    next_position = (1..OwnedMonster::MAX_PARTY_SIZE).find do |position|
      !@active_monsters.exists?(party_position: position)
    end

    @owned_monster.update!(
      active: true,
      party_position: next_position
    )
  end

  def remove_monster
    @owned_monster.update!(
      active: false,
      party_position: nil
    )
  end

  private

  def load_party_data
    @inactive_monsters = current_user.owned_monsters.inactive.order(created_at: :asc)
    @active_monsters = current_user.owned_monsters.active.order(:party_position)
  end

  def set_owned_monster
    @owned_monster = current_user.owned_monsters.find(params[:owned_monster_id])
  end

  def ensure_not_adventuring
    return unless current_user.adventuring?
    redirect_to new_adventure_path, alert: "冒険中はパーティを変更できません"
  end
end
