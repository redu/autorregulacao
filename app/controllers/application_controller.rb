class ApplicationController < BaseController
  before_filter :verify_current_user

  protected

  # Verifies if current_user exists and redirects to authentication action if
  # doesn't
  def verify_current_user
    unless current_user
      redirect = request.fullpath
      Rails.logger.info "verify_current_user: storing #{redirect} on session"
      session['redirect_to'] = redirect
      redirect_to create_session_path(provider: :redu)
    end
  end
end
