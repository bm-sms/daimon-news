after 'development:sites' do
  site1 = Site.find_by!(name: 'site1')

  site1.page_meta_informations.create!(
    path:        '/',
    description: 'description of site1'
  )
  site1.page_meta_informations.create!(
    path:        '/policy',
    description: 'privacy policy',
    noindex:     true
  )
end
