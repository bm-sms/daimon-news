Site.create!(
  name: 'site1',
  fqdn: ENV['HEROKU_APP_NAME'].present? ? "#{ENV['HEROKU_APP_NAME']}.herokuapp.com" : 'localhost',
)

Site.create!(
  name:    'site2',
)
