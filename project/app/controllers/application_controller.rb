class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  helper_method :authenticate_user

  def authenticate_user(*roles)
    unless roles.include? "Visitor"
      unless session[:current_userid] and (roles.empty? or roles.include? session[:current_role])
        redirect_to login_users_path, alert: "Please login first."
        return false
      end
    end
    if session[:current_userid]
      @current_user ||= User.find(session[:current_userid])
    end
    true
  end

  def assert_current_user(expected_id, *additional_roles)
    unless additional_roles.include?(session[:current_role]) || @current_user.id == expected_id
      puts "assert_current_user failed, expected_id: #{expected_id}, current_user.id: #{@current_user.id}"
      redirect_to login_users_path, alert: "You are not authorized to access this page."
      return false
    end
    true
  end
end
