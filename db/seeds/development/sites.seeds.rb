Site.create!(
  name: 'site1',
  fqdn: ENV['HEROKU_APP_NAME'].present? ? "#{ENV['HEROKU_APP_NAME']}.herokuapp.com" : 'localhost',
  js_url:  'themes/default/application',
  css_url: 'themes/default/application'
)

Site.create!(
  name:    'site2',
  js_url:  'themes/default/application',
  css_url: 'themes/default/application'
)
