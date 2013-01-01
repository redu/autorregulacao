class BaseController < ActionController::Base
  protect_from_forgery
  helper_method :current_user
  before_filter :log_current_user

  protected

  def current_user
    if session.has_key? :user_id
      @current_user ||= User.find_by_id(session[:user_id])
    end
  end

  def log_current_user
    Rails.logger.info "Current loged in user is: #{current_user.to_json}"
  end
end
