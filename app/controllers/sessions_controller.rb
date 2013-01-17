class SessionsController < BaseController
  respond_to :html, :json

  def create
    @user = User.find_by_uid(auth_hash['uid']) ||
      User.create_with_omniauth(auth_hash)

    Rails.logger.info "Adding #{@user.id} to the session[:user_id]"
    session[:user_id] = @user.id

    redirect_to new_ar_exercise_path
  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end
end
