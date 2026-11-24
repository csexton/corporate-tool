ruby File.open(".ruby-version", "rb") { |f| f.read.chomp }
source "https://rubygems.org"

gem "rails", "~> 8.1.4"

gem "pg"
gem "pg_search"
gem "puma"

gem "aws-sdk-s3", require: false
gem "kaminari"
gem "omniauth-google-oauth2"
gem "omniauth-rails_csrf_protection"
gem "paper_trail"

# Markdown

gem "gemoji"
gem "kramdown"
gem "kramdown-parser-gfm"
gem "rouge"

# Views

gem "jbuilder"
gem "slim-rails"

# Assets

gem "bootstrap", "~> 4.0"
gem "font-awesome-rails"
gem "sass-rails"

# Javascript

gem "jquery-rails"
gem "uglifier", ">= 1.3.0"

group :development, :test do
  gem "better_errors"
  gem "binding_of_caller"
  gem "capybara"
  gem "dotenv-rails"
  gem "launchy"
  gem "ostruct"
  gem "pry-byebug"
  gem "pry-rails"
  gem "rspec-rails"
end

group :development do
  gem "pry-rescue"
  gem "pry-stack_explorer"
end
