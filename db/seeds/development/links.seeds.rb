after 'development:sites' do
  site1 = Site.find_by!(name: 'site1')

  site1.links.create!(
    text:        'exapmle',
    url:         'http://exapmle.com/',
    order:       1
  )
  site1.links.create!(
    text:        'sms',
    url:         'http://bm-sms.co.jp/',
    order:       2
  )
end
