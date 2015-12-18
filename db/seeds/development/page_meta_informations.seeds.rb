after 'development:sites' do
  site1 = Site.find_by!(name: 'site1')

  site1.page_meta_informations.create!(
    path:        '/',
    description: 'description of site1'
  )
  site1.page_meta_informations.create!(
    path:        '/about',
    title:       'About site1',
    description: "What's site1?"
  )
  site1.page_meta_informations.create!(
    path:        '/policy',
    title:       'Privacy Policy',
    description: 'This is the privacy policy page.',
    noindex:     true
  )
end
