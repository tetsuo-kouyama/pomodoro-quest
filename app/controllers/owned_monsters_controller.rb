class OwnedMonstersController < ApplicationController
  before_action :require_login
  before_action :set_owned_monster

  def index
    @owned_monsters = current_user.owned_monsters.includes(:monster)
  end

  def new
    @owned_monster = OwnedMonster.new
    @monsters = Monster.all
  end

  def create
    @monster = Monster.find(owned_monster_params[:monster_id])
    @owned_monster = current_user.owned_monsters.build(owned_monster_params)

    current_user.hire_monster!(@owned_monster, @monster)

    redirect_to owned_monsters_path, notice: "#{@owned_monster.nickname}を雇用しました！"

  rescue User::InsufficientGoldError
    reload_form_on_failure("ゴールドが足りません(必要: #{@monster.hire_cost}G / 所持: #{current_user.gold}G)")
  rescue ActiveRecord::RecordInvalid
    # DBの最新状態を再取得することで、エラー時にgoldが減っているように見える問題を解決
    current_user.reload
    reload_form_on_failure("雇用できませんでした")
  end

  def show; end

  def levelup
    @owned_monster.increment_level!(current_user)
    redirect_to owned_monster_path(@owned_monster), notice: "レベルアップしました！"

  rescue User::InsufficientGoldError
    redirect_to owned_monster_path(@owned_monster), alert: "ゴールドが足りません(必要: #{@owned_monster.next_level_cost}G / 所持: #{current_user.gold}G)"
  end


  private

  def owned_monster_params
    params.require(:owned_monster).permit(:nickname, :monster_id)
  end

  def reload_form_on_failure(message = nil)
    flash.now[:alert] = message if message
    @monsters = Monster.all
    render :new, status: :unprocessable_entity
  end

  def set_owned_monster
    @owned_monster = current_user.owned_monsters.find(params[:id])
  end
end
