after 'development:sites' do
  site1 = Site.find_by!(name: 'site1')

  site1.categories.create!(
    name:        'category 1',
    description: 'category 1',
    slug:        'category1'
  )
  site1.categories.create!(
    name:        'category 2',
    description: 'category 2',
    slug:        'category2'
  )
end
