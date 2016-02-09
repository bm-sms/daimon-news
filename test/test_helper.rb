ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'test/unit/rails/test_help'

require 'factory_girl'
FactoryGirl.find_definitions

require 'capybara/poltergeist'
Capybara.javascript_driver = :poltergeist

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  include FactoryGirl::Syntax::Methods
end

def DatabaseCleaner.default_strategy
  :transaction
end

DatabaseCleaner.strategy = DatabaseCleaner.default_strategy
DatabaseCleaner.clean_with :truncation
