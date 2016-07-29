Site.create!(
  name: "site1",
  fqdn: ENV["HEROKU_APP_NAME"].present? ? "#{ENV['HEROKU_APP_NAME']}.herokuapp.com" : "localhost",
  opened: true,
  public_participant_page_enabled: true
)

Site.create!(
  name:   "site2",
  fqdn:   "lvh.me",
  opened: false,
  public_participant_page_enabled: true
)
