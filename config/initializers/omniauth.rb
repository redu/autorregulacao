Rails.application.config.middleware.use OmniAuth::Builder do
  provider :redu,  ENV['REDU_KEY'], ENV['REDU_SECRET']
end
