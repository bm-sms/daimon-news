after 'development:sites' do
  site1 = Site.find_by!(name: 'site1')

  site1.credit_roles.create!(
    name:  '著者',
    order: 1
  )
  site1.credit_roles.create!(
    name:  '解説',
    order: 2
  )
end
