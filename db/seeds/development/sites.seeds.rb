Site.create!(
  name: "site1",
  fqdn: ENV["HEROKU_APP_NAME"].present? ? "#{ENV['HEROKU_APP_NAME']}.herokuapp.com" : "localhost",
  opened: true,
  public_participant_page_enabled: true,
  hierarchical_categories_enabled: true,
  js_url: "http://localhost:3000/assets/daimon-news.js",
  css_url: "http://localhost:3000/assets/application.css",
  content_header_url: "http://localhost:3000/partials/content_header_buttons",
)

Site.create!(
  name:   "site2",
  fqdn:   "lvh.me",
  opened: false,
  public_participant_page_enabled: true,
  hierarchical_categories_enabled: true
)
