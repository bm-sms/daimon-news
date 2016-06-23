require "fileutils"
require "groonga"

Groonga::Logger.path = "tmp/groonga.log"

database_path = ENV["GROONGA_DATABASE_PATH"] || "groonga/data/db"
if File.exist?(database_path)
  Groonga::Database.open(database_path)
else
  FileUtils.mkdir_p(File.dirname(database_path))
  Groonga::Database.create(path: database_path)
end
