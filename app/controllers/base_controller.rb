class BaseController < ActionController::Base
  protect_from_forgery
  helper_method :current_user
  before_filter :log_current_user

  protected

  # Gets possible loged in user from session
  def session_user
    return @session_user if defined? @session_user
    if session.has_key? :user_id
      @session_user ||= User.find_by_id(session[:user_id])
    end
  end

  # Verifies if the loged in user is the same passed by the canvas provider
  def current_user
    return @current_user if defined? @current_user
    return session_user unless params[:user_id]

    user_id = params[:user_id]
    if session_user.try(:uid) == user_id
      @current_user ||= session_user
    end
  end

  def log_current_user
    Rails.logger.info "Current loged in user is: #{current_user.to_json}"
  end
end
