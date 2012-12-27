class ApplicationController < BaseController
  before_filter :verify_current_user

  protected

  # Verifies if current_user exists and redirects to authentication action if
  # doesn't
  def verify_current_user
    redirect_to create_session_path(provider: :redu) unless current_user
  end
end
