after 'development:credit_roles', 'development:participants', 'development:posts' do
  site1 = Site.find_by!(name: 'site1')
  participants = site1.participants.cycle
  credit_roles = site1.credit_roles.cycle

  site1.posts.published.order_by_recently.limit(10).each do |post|
    post.credits.create!(
      participant: participants.next,
      role: credit_roles.next
    )
  end
end
