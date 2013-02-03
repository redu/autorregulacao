class RemoteService
  include Rails.application.routes.url_helpers
  include Virtus

  attr_writer :client

  attribute :resource
  attribute :user, User, default: lambda { |service, attrs|
    service.resource.user
  }

  def client
    @client ||= Redu::Client.new(oauth_token_secret: user.token)
  end

  protected

  def client_application_id
    Autoregulation::Application.config.client_id
  end

  def default_url_options
    { host: Autoregulation::Application.config.host }
  end
end
