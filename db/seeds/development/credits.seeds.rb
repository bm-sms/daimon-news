after 'development:credit_roles', 'development:participants', 'development:posts' do
  site1 = Site.find_by!(name: 'site1')
  participant = site1.participants.first!
  credit_role = site1.credit_roles.first!

  site1.posts.published.order_by_recently.limit(3).each do |post|
    post.credits.create!(
      participant: participant,
      role: credit_role
    )
  end
end
