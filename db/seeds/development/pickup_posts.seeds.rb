after "development:posts" do
  site1 = Site.find_by!(name: "site1")

  posts = site1.posts.limit(3)

  posts.each_with_index do |post, index|
    site1.pickup_posts.create(site: site1, post: post, order: index + 1)
  end
end
