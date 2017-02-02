after "development:posts" do
  site1 = Site.find_by!(name: "site1")

  posts = site1.posts.limit(5)

  posts.each.with_index(1) do |post, index|
    site1.popular_posts.create(site: site1, post: post, rank: index)
  end
end
