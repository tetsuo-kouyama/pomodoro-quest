module ApplicationHelper
  def display_name
    nickname.presence || monster.name
  end
end
