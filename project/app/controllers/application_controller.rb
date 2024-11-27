class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  helper_method :authenticate_user

  def authenticate_user(*roles)
    unless roles.empty? or (session[:current_userid] and (roles.include? session[:current_role]))
      redirect_to login_users_path, alert: "Please login first."
      return
    end
    if session[:current_userid]
      @current_user ||= User.find(session[:current_userid])
    end
  end
end
