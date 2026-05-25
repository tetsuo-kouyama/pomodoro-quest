class AdventuresController < ApplicationController
  def new
    @active_monsters = current_user.owned_monsters.where(active: true).order(:party_position)
    @required_times = Adventure::DURATIONS
    @dungeons = Dungeon.order(:difficulty)
  end

  def create
  end
end
