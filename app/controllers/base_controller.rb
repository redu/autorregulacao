class BaseController < ActionController::Base
  protect_from_forgery
  helper_method :current_user

  protected

  def current_user
    @current_user ||= begin
      User.find_by_id(session[:user_id])
    end if session[:user_id]
  end
end
