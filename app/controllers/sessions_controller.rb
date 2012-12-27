class SessionsController < BaseController
  respond_to :html, :json

  def create
    @user = User.find_by_uid(auth_hash['uid']) ||
      User.create_with_omniauth(auth_hash)

    session[:user_id] = @user.id

    respond_with(@user)
  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end
end
