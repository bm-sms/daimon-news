after "development:sites", "development:posts" do
  site1 = Site.find_by!(name: "site1")

  posts = site1.posts.limit(2)

  posts.each.with_index(1) do |post, index|
    site1.top_fixed_posts.create(site: site1, post: post, order: index)
  end
end
