after "development:sites", "development:categories" do
  site1 = Site.find_by!(name: "site1")
  site1.posts.create!(
    title: "Hello",
    body: <<-EOS.strip_heredoc,
      # Hello
      hi !

      This is first post for site 1!
    EOS
    thumbnail: open(Rails.root.join("db/data/thumbnail.jpg")),
    published_at: Time.current,
    category: site1.categories.find_by!(slug: "category1"),
  )

  published_at = 3.minutes.from_now

  site1.posts.create!(
    title: "This post will appear at #{published_at}",
    body: <<-EOS.strip_heredoc,
      # Hello
      hi !

      This post will appear at #{published_at}
    EOS
    thumbnail: open(Rails.root.join("db/data/thumbnail.jpg")),
    published_at: published_at,
    category: site1.categories.find_by!(slug: "category2"),
  )

  50.times do |i|
    i += 100

    site1.posts.create!(
      title: "Post #{i}",
      body: <<~EOS,
        page 1

        <!--nextpage-->

        page 2

        <!--nextpage-->

        page 3
      EOS
      thumbnail: open(Rails.root.join("db/data/thumbnail.jpg")),
      published_at: Time.current,
      category: site1.categories.find_by!(slug: "category1"),
    )
  end

  # below records: id != public_id
  site1.posts.create!(
    title: "Hello",
    body: <<-EOS.strip_heredoc,
      # Hello
      hi !

      This is post `id != public_id`!
    EOS
    public_id: 100_000,
    thumbnail: open(Rails.root.join("db/data/thumbnail.jpg")),
    published_at: Time.current,
    category: site1.categories.find_by!(slug: "category2"),
  )

  50.times do |i|
    i += 100

    site1.posts.create!(
      title: "Post #{i}",
      body: <<~EOS,
        page 1

        <!--nextpage-->

        page 2

        <!--nextpage-->

        page 3
      EOS
      thumbnail: open(Rails.root.join("db/data/thumbnail.jpg")),
      published_at: Time.current,
      category: site1.categories.find_by!(slug: "category2"),
    )
  end
end
