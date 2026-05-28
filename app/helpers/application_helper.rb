module ApplicationHelper
  def show_navigation?
  logged_in? && !hide_navigation?
  end

  private

  def hide_navigation?
    static_top_page? || auth_page?
  end

  def static_top_page?
    controller_name == "static_pages" && action_name == "top"
  end

  def auth_page?
    (controller_name == "sessions" && action_name.in?(%w[new create])) ||
      (controller_name == "users" && action_name.in?(%w[new create]))
  end
end
