class OwnedMonstersController < ApplicationController
  before_action :require_login

  def index
    @owned_monsters = current_user.owned_monsters.includes(:monster)
  end
end
