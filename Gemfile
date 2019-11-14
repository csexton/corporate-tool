ruby File.open(".ruby-version", "rb") { |f| f.read.chomp }
source "https://rubygems.org"
source "https://rails-assets.org"

gem "rails", "5.2.0"

gem "pg"
gem "pg_search"
gem "puma"
gem "redis"

gem "aws-sdk-s3", require: false
gem "kaminari"
gem "omniauth-google-oauth2"
gem "paper_trail"
gem "rails_12factor", group: :production

# Markdown

gem "gemoji"
gem "github-markup", require: "github/markup"
gem "kramdown"
gem "rouge"

# Views

gem "jbuilder", "~> 2.5"
gem "nested_form"
gem "slim-rails"

# Assets

gem "bootstrap", "~> 4.3"
gem "font-awesome-rails"
gem "rails-assets-ace-builds"
gem "sass-rails"

# Javascript

gem "coffee-rails", "~> 4.2"
gem "jquery-rails"
gem "uglifier", ">= 1.3.0"

group :development, :test do
  gem "better_errors"
  gem "binding_of_caller"
  gem "capybara"
  gem "database_cleaner"
  gem "dotenv-rails"
  gem "launchy"
  gem "pry-byebug"
  gem "pry-rails"
  gem "rspec-rails"
end

group :development do
  gem "pry-rescue"
  gem "pry-stack_explorer"
  gem "spring"
end
