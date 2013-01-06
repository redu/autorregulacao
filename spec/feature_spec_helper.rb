require 'spec_helper'
require 'capybara/rails'
require 'capybara/rspec'

Capybara.configure do |config|
  config.ignore_hidden_elements = false
end

