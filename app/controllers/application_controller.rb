class ApplicationController < ActionController::Base
  allow_browser versions: :modern

  helper_method :current_user, :logged_in?

  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def require_login
    unless current_user
      redirect_to login_path, alert: "ログインして下さい"
    end
  end

  def logged_in?
    current_user.present?
  end
end
