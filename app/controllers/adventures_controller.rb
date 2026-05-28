class AdventuresController < ApplicationController
  def index
    @adventures = current_user.adventures.includes(:dungeon).order(created_at: :desc).limit(20)
  end

  def new
    @current_adventure = current_user.adventures.unclaimed.order(start_at: :desc).first

    if @current_adventure
      @current_adventure.check_completion!
      @dungeon = @current_adventure.dungeon
      @adventure_members = @current_adventure.adventure_members.includes(owned_monster: :monster)
    else
      @adventure = Adventure.new
      @active_monsters = current_user.owned_monsters.active.order(:party_position)
      @dungeons = Dungeon.order(:difficulty)
    end
  end

  def create
    if current_user.adventures.ongoing.exists?
      redirect_to new_adventure_path, alert: "冒険中です"
      return
    end

    active_monsters = current_user.owned_monsters.active.order(:party_position)

    if active_monsters.empty?
      redirect_to new_adventure_path, alert: "パーティを編成してください"
      return
    end

    @adventure = current_user.adventures.new(adventure_params)

    # 冒険に出発させるパーティメンバーと冒険データを紐付ける
    @adventure.assign_members(active_monsters)

    @adventure.prepare_for_departure!

    if @adventure.save
      redirect_to new_adventure_path, notice: "冒険に出発しました!"
    else
      @active_monsters = active_monsters
      @dungeons = Dungeon.order(:difficulty)
      render :new, status: :unprocessable_entity
    end
  end

  def claim
    ActiveRecord::Base.transaction do
      @adventure = current_user.adventures.lock.find(params[:id])

      unless @adventure.finished?
        redirect_to new_adventure_path, alert: "報酬を受け取れません"
        return
      end

      result = @adventure.resolve_combat

      final_reward = result[:reward]
      is_victory = result[:victory]

      current_user.update!(gold: current_user.gold + final_reward)
      @adventure.update!(status: :claimed, reward_gold: final_reward)

      flash_message =
        if is_victory
          "🎉 冒険大成功！ #{final_reward}G を獲得しました！"
        else
          "💀 冒険は失敗した… 命からがら #{final_reward}G を持ち帰った"
        end

      redirect_to new_adventure_path, notice: flash_message
    end
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error e.message
    redirect_to new_adventure_path, alert: "エラーが発生しました"
  end

  private

  def adventure_params
    params.require(:adventure).permit(:dungeon_id, :required_time)
  end
end
