after 'development:sites' do
  site1 = Site.find_by!(name: 'site1')

  site1.authors.create!(
    name: 'name11',
    description: "description11"
  )
  site1.authors.create!(
    name: 'name12',
    description: "description12"
  )


  site2 = Site.find_by!(name: 'site2')

  site2.authors.create!(
    name: 'name21',
    description: "description21"
  )
  site2.authors.create!(
    name: 'name22',
    description: "description22"
  )
end
