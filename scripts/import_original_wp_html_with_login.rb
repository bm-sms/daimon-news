require "uri"
require "optparse"
require "capybara"
require "capybara/poltergeist"

user = nil
password = nil
login_uri = nil
base_uri = nil

parser = OptionParser.new

parser.on("-u", "--user=USER", "User") do |u|
  user = u
end

parser.on("-p", "--password=PASS", "Password") do |pass|
  password = pass
end

parser.on("-l", "--login-uri=URI", "Login URI") do |uri|
  login_uri = URI(uri)
end

parser.on("--base-uri=URI", "Base URI") do |uri|
  base_uri = URI(uri)
end

begin
  parser.parse!
rescue OptionParser::ParseError => ex
  $stderr.puts ex.message
  $stderr.puts parser.help
end

Capybara.default_driver = :poltergeist
Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, js_errors: false)
end

user_agent = "Mozilla/5.0 (Windows NT 6.1; WOW64; rv:44.0) Gecko/20100101 Firefox/44.0"

session = Capybara::Session.new(:poltergeist)
session.driver.headers = {
  "User-Agent" => user_agent
}

session.visit login_uri

session.fill_in "mail_address", with: user
session.fill_in "password", with: password

login_button = session.all("a").detect do |element|
  element[:id] == "btn_login"
end

login_button.click

site = Site.find_by!(fqdn: fqdn)

site.transaction do
  site.posts.each do |post|
    sources = []
    content_uri = base_uri + post.public_id
    session.visit content_uri
    source << session.source
    links = session.all("a").select do |a|
      a[:href].start_with?(session.currnt_url)
    end
    links.each do |link|
      link.click
      sources << session.source
    end
    post.update!(original_html: sources.join("\n\n<!--PAGINATE-->\n\n"))
  end
end
