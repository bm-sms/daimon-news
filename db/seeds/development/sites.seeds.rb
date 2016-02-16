Site.create!(
  name: 'site1',
  fqdn: ENV['HEROKU_APP_NAME'].present? ? "#{ENV['HEROKU_APP_NAME']}.herokuapp.com" : 'localhost',
  opened: true
)

Site.create!(
  name:   'site2',
  fqdn:   'lvh.me',
  opened: false
)
