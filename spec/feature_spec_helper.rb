require 'spec_helper'
require 'capybara/rails'
require 'capybara/rspec'

Capybara.configure do |config|
  include OmniAuth::Integration
  config.ignore_hidden_elements = false
end

