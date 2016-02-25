require 'fileutils'
require 'groonga'

database_path = ENV['GROONGA_DATABASE_PATH'] || 'groonga/data/db'
if File.exist?(database_path)
  Groonga::Database.open(database_path)
else
  FileUtils.mkdir_p(File.dirname(database_path))
  Groonga::Database.create(path: database_path)
end
