require 'rubygems'

#Bundler.require(:default, "development")


ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../test/rails_app/config/environment", __FILE__)
require 'rspec/rails'
require './lib/initializers/sprockets_helper.rb'
RSpec.configure do |config|
  # == Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  config.mock_with :rspec
end
