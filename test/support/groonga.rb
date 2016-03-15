module GroongaHelper
  extend ActiveSupport::Concern

  def setup_groonga_database
    teardown_groonga_database
    FileUtils.mkdir_p(groonga_database_dir)
    if File.exist?(groonga_database_path)
      Groonga::Database.open(groonga_database_path)
    else
      Groonga::Database.create(path: groonga_database_path)
    end
    load Rails.root.join("groonga/init.rb")
  end

  def teardown_groonga_database
    context = Groonga::Context.default
    database = context.database
    if database
      database.tables.each(&:truncate)
      database.close
    end
    context.close
    Groonga::Context.default = nil
  end

  def groonga_database_path
    File.join(groonga_database_dir, "#{Rails.env}.db")
  end

  def groonga_database_dir
    Rails.root.join("groonga/data/#{Rails.env}").to_s
  end
end

ActionDispatch::IntegrationTest.include(GroongaHelper)
