class ApplicationController < BaseController
  before_filter :verify_current_user

  protected

  # Verifies if current_user exists and redirects to authentication action if
  # doesn't
  def verify_current_user
    unless current_user
      return_path = request.fullpath
      Rails.logger.info "verify_current_user: keeping path to redirect back #{return_path}"
      redirect_to create_session_path(provider: :redu, :origin => return_path)
    end
  end
end
