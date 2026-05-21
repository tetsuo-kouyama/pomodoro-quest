class OwnedMonstersController < ApplicationController
  before_action :require_login

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
    @owned_monster.nickname = @monster.name if @owned_monster.nickname.blank?

    return if gold_check_failed?

    execute_hire_transaction

    redirect_to owned_monsters_path, notice: "#{@owned_monster.nickname}を雇用しました！"

  rescue ActiveRecord::RecordInvalid
    @monsters = Monster.all
    reload_form_on_failure("雇用できませんでした")
  end

  private

  def owned_monster_params
    params.require(:owned_monster).permit(:nickname, :monster_id)
  end

  def gold_check_failed?
    return false if current_user.gold >= @monster.hire_cost

    flash.now[:alert] = "ゴールドが足りません(必要: #{@monster.hire_cost}G / 所持: #{current_user.gold}G)"
    reload_form_on_failure
    true
  end

  def execute_hire_transaction
    ActiveRecord::Base.transaction do
      current_user.decrement!(:gold, @monster.hire_cost)
      @owned_monster.save!
    end
  end

  def reload_form_on_failure(message = nil)
    flash.now[:alert] = message if message
    @monsters = Monster.all
    render :new, status: :unprocessable_entity
  end
end
