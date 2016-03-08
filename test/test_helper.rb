ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'test/unit/rails/test_help'

Dir[Rails.root.join('test/support/**/*.rb')].each {|f| require f }

require 'factory_girl'
FactoryGirl.find_definitions

require 'capybara/poltergeist'
Capybara.javascript_driver = :poltergeist

class ActiveSupport::TestCase
  # Add more helper methods to be used by all tests here...
  include FactoryGirl::Syntax::Methods

  def setup_groonga_database
    teardown_groonga_database
    FileUtils.mkdir_p(groonga_database_dir)
    Groonga::Database.create(path: groonga_database_path)
    load Rails.root.join("groonga/init.rb")
  end

  def teardown_groonga_database
    context = Groonga::Context.default
    database = context.database
    database.close if database
    context.close
    Groonga::Context.default = nil
    FileUtils.rm_rf(groonga_database_dir)
  end

  def groonga_database_path
    File.join(groonga_database_dir, "#{Rails.env}.db")
  end

  def groonga_database_dir
    Rails.root.join("groonga/data/#{Rails.env}").to_s
  end
end
