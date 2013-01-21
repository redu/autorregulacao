# Be sure to restart your server when you modify this file.

if Rails.env.production?
  Autoregulation::Application.config.session_store :active_record_store,
    key: '_autoregulation_session',
    domain: '.autorregulacao.heroku.com'
else
  Autoregulation::Application.config.session_store :active_record_store,
    key: '_autoregulation_session'
end
