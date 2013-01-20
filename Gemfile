source 'https://rubygems.org'

gem 'rails', '~> 3.2.10'
gem 'omniauth-redu', git: 'git://github.com/redu/omniauth-redu.git'
gem 'factory_girl_rails'
gem 'virtus'
gem 'redu', git: 'git://github.com/redu/redu-ruby.git'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'

group :test do
  gem 'rspec-rails'
  gem 'shoulda-matchers'
  gem 'capybara'
end

group :test, :development do
  # To use debugger
  gem 'debugger'
  gem 'sqlite3'
end

group :production do
  gem 'pg'
end

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'
