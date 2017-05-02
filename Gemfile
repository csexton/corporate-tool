ruby File.open('.ruby-version', 'rb') { |f| f.read.chomp }
source 'https://rubygems.org'
source 'https://rails-assets.org'

gem 'rails', '5.0.2'
gem 'pg'
gem 'puma'
gem 'redis'

gem 'kaminari', git: "https://github.com/amatsuda/kaminari.git", branch: 'master'
gem 'aws-sdk', require: false
gem 'rails_12factor',   group: :production
gem "omniauth-google-oauth2"

# Markdown

gem 'redcarpet'
gem 'github-markup', require: 'github/markup'
gem 'pygments.rb'
gem 'gemoji'

# Views

gem 'slim-rails'
gem 'jbuilder', '~> 2.5'
gem 'nested_form'

# Assets

gem 'font-awesome-rails'
gem 'sass-rails'
gem 'bootstrap', '~> 4.0.0.alpha6'
gem 'rails-assets-ace-builds'

# Javascript

gem 'jquery-rails'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'

# Documentation

gem 'sdoc',          group: :doc, require: false

group :development, :test do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'dotenv-rails'
  gem 'rspec-rails'
  gem 'capybara'
  gem 'launchy'
  gem 'pry-rails'
  gem 'pry-byebug'
  gem 'database_cleaner'
end

group :development do
  gem 'pry-rescue'
  gem 'pry-stack_explorer'
  gem 'spring'
end
