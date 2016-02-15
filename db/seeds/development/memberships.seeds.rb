after 'development:sites', 'development:users' do
  site1 = Site.find_by!(name: 'site1')
  editor = User.find_by!(email: 'editor@example.com')

  site1.memberships.create!(user: editor)
end
