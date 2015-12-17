after 'development:sites' do
  site1 = Site.find_by!(name: 'site1')

  site1.meta_tags.create!(
    name:    'keywords',
    content: 'daimon,news'
  )
  site1.meta_tags.create!(
    name:    'description',
    content: 'This is a sample site.'
  )
end
