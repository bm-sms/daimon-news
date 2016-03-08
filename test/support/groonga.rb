module GroongaHelper
  extend ActiveSupport::Concern

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

ActionDispatch::IntegrationTest.include(GroongaHelper)
