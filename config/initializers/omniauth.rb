Rails.application.config.middleware.use OmniAuth::Builder do
  provider :redu,  ENV['REDU_KEY'], ENV['REDU_SECRET']

  OmniAuth.config.logger = Rails.logger
  on_failure do |env|
    [200, {}, [env['omniauth.error'].inspect]]
  end
end
