require 'fileutils'
require 'groonga'

log_options = {
  location: false,
}
Groonga::Logger.register(log_options) do |event, level, _, _, message, _|
  if event == :log
    formatted_message = "Groonga|#{message}"
    case level
    when :emergency, :alert, :critical
      Rails.logger.fatal(formatted_message)
    when :error
      Rails.logger.fatal(formatted_message)
    when :warning
      Rails.logger.warn(formatted_message)
    when :notice, :info
      Rails.logger.info(formatted_message)
    when :debug, :dump
      Rails.logger.debug(formatted_message)
    else
      Rails.logger.unknown(formatted_message)
    end
  end
end

database_path = ENV['GROONGA_DATABASE_PATH'] || 'groonga/data/db'
if File.exist?(database_path)
  Groonga::Database.open(database_path)
else
  FileUtils.mkdir_p(File.dirname(database_path))
  Groonga::Database.create(path: database_path)
end
