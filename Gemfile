ruby '2.2.2'

source 'https://rubygems.org'

gem 'rails', '~> 4.2.1'
gem 'pg'
gem 'uglifier'
gem 'jquery-rails'
gem 'coffee-script'
gem 'devise'
gem 'devise_invitable'
gem 'stripe', github: 'zachflower/stripe-ruby'
gem 'chartkick'
gem 'groupdate'
gem 'mailgun-ruby', require: 'mailgun'
gem 'nested_form_fields'
gem 'redcarpet'
gem 'deep_cloneable'
gem 'cancancan'
gem 'jquery-ui-rails'
gem 'validate_url'
gem 'gravatarify'
gem 'hellosign-ruby-sdk'
gem 'closeio'

group :development do
  gem 'spring'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'quiet_assets'
  gem "letter_opener"
end

group :test, :development do
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'awesome_print'
  gem 'dotenv-rails'
  gem 'pry'
end

group :test do
  gem 'capybara'
  gem 'shoulda-matchers'
  gem 'launchy'
  gem 'poltergeist'
  gem 'database_cleaner'
  gem 'webmock', require: false
  gem 'vcr'
  gem 'puffing-billy'
  gem 'simplecov', require: false
  gem 'coveralls', require: false
end

group :production do
  gem 'rails_12factor'
  gem 'unicorn'
  gem 'newrelic_rpm'
  gem 'bugsnag'
  gem 'lograge'
  gem 'oink'
end
