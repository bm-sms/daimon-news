after 'development:sites' do
  site1 = Site.find_by!(name: 'site1')

  site1.meta_tags.create!(
    path:        '/',
    description: 'description of site1'
  )
  site1.meta_tags.create!(
    path:        '/policy',
    description: 'privacy policy',
    noindex:     true
  )
end
