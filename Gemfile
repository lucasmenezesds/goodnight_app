# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.4'

# JSON Object Presenter for Ruby
gem 'blueprinter', '~> 0.25.3'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails', branch: 'main'
gem 'rails', '~> 6.1.7', '>= 6.1.7.3'

# Soft-delete
gem 'paranoia', '~> 2.6', '>= 2.6.2'

# Use postgresql as the database for Active Record
gem 'pg', '~> 1.1'

# Use Pry as your rails console
gem 'pry-rails', '~> 0.3.9'

# Use Puma as the app server
gem 'puma', '~> 5.0'

# Catch unsafe migrations in development => https://github.com/ankane/strong_migrations
gem 'strong_migrations', '~> 1.4', '>= 1.4.4'

# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
# gem 'rack-cors'

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'database_cleaner-active_record', '~> 2.1' # Avoid flaky tests by cleaning databases using ActiveRecord
  gem 'dotenv-rails', '~> 2.8', '>= 2.8.1'
  gem 'factory_bot', '~> 6.2', '>= 6.2.1'
  gem 'factory_bot_rails', '~> 6.2'
  gem 'faker', '~> 3.2'
  gem 'guard', '~> 2.18'
  gem 'guard-rspec', '~> 4.7', '>= 4.7.3'
  gem 'pry-byebug', '~> 3.10', '>= 3.10.1'
  gem 'rspec-rails', '~> 6.0', '>= 6.0.3'
  gem 'rubocop-rails', '~> 2.19', '>= 2.19.1'
  gem 'rubocop-rspec', '~> 2.22'
  gem 'simplecov', '~> 0.22.0'
  gem 'timecop', '~> 0.9.6'
end

group :development do
  gem 'listen', '~> 3.3'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
