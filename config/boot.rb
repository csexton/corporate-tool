# Set up gems listed in the Gemfile.
ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)

require 'bundler/setup' if File.exist?(ENV['BUNDLE_GEMFILE'])

# Rails 7.0 + concurrent-ruby >= 1.3.5 needs Logger loaded before ActiveSupport
require "logger"
