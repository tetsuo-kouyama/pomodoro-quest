class AdventuresController < ApplicationController
  def new
    @adventure = Adventure.new
    @active_monsters = current_user.owned_monsters.active_party
    @dungeons = Dungeon.order(:difficulty)
  end

  def create
    if current_user.adventures.ongoing.exists?
      redirect_to new_adventure_path, alert: "冒険中です"
      return
    end

    active_monsters = current_user.owned_monsters.active_party

    if active_monsters.empty?
      redirect_to new_adventure_path, alert: "パーティを編成してください"
      return
    end

    @adventure = current_user.adventures.new(adventure_params)

    # 冒険に出発させるパーティメンバーと冒険データを紐付ける
    active_monsters.each do |monster|
      @adventure.adventure_members.build(owned_monster_id: monster.id, slot: monster.party_position)
    end

    @adventure.start_at = Time.current
    @adventure.end_at = @adventure.start_at + @adventure.required_time.to_i
    @adventure.reward_gold = @adventure.dungeon.reward_gold
    @adventure.status = :ongoing

    if @adventure.save
      redirect_to new_adventure_path, notice: "冒険に出発しました!"
    else
      @active_monsters = active_monsters
      @dungeons = Dungeon.order(:difficulty)
      render :new, status: :unprocessable_entity
    end
  end

  private

  def adventure_params
    params.require(:adventure).permit(:dungeon_id, :required_time)
  end
end
