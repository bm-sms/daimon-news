after 'development:sites' do
  site1 = Site.find_by!(name: 'site1')

  site1.links.create!(
    text:  'about',
    url:   '/about',
    order: 1
  )
  site1.links.create!(
    text:  'policy',
    url:   '/policy',
    order: 2
  )
  site1.links.create!(
    text:  'company',
    url:   'http://bm-sms.co.jp/',
    order: 3
  )
end
