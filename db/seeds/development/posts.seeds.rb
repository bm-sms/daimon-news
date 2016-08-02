after "development:sites", "development:categories" do
  site1 = Site.find_by!(name: "site1")
  category1 = site1.categories.find_by!(slug: "category1")
  category2 = site1.categories.find_by!(slug: "category2")
  post = site1.posts.create!(
    title: "Hello",
    body: <<-EOS.strip_heredoc,
      # Hello
      hi !

      This is first post for site 1!
    EOS
    thumbnail: Rails.root.join("db/data/thumbnail.jpg").open,
    published_at: Time.current,
    categorizations_attributes: [{category: category1, order: 1}],
  )

  published_at = 3.minutes.from_now

  post = site1.posts.create!(
    title: "This post will appear at #{published_at}",
    body: <<-EOS.strip_heredoc,
      # Hello
      hi !

      This post will appear at #{published_at}
    EOS
    thumbnail: Rails.root.join("db/data/thumbnail.jpg").open,
    published_at: published_at,
    categorizations_attributes: [{category: category2, order: 1}],
  )

  paginate_body = <<~EOS
    page 1

    <!--nextpage-->

    page 2

    <!--nextpage-->

    page 3
  EOS

  50.times do |i|
    i += 100

    post = site1.posts.create!(
      title: "Post #{i}",
      body: paginate_body,
      thumbnail: Rails.root.join("db/data/thumbnail.jpg").open,
      published_at: Time.current,
      categorizations_attributes: [{category: category2, order: 1}],
    )
  end

  # below records: id != public_id
  post = site1.posts.create!(
    title: "Hello",
    body: <<-EOS.strip_heredoc,
      # Hello
      hi !

      This is post `id != public_id`!
    EOS
    public_id: 100_000,
    thumbnail: Rails.root.join("db/data/thumbnail.jpg").open,
    published_at: Time.current,
    categorizations_attributes: [{category: category2, order: 1}],
  )

  50.times do |i|
    i += 100

    post = site1.posts.create!(
      title: "Post #{i}",
      body: paginate_body,
      thumbnail: Rails.root.join("db/data/thumbnail.jpg").open,
      published_at: Time.current,
      categorizations_attributes: [{category: category2, order: 1}],
    )
  end

  25.times do |i|
    i += site1.posts.maximum(:public_id)
    post = site1.posts.create!(
      title: "Post #{i}",
      body: paginate_body,
      thumbnail: Rails.root.join("db/data/thumbnail.jpg").open,
      published_at: Time.current,
      categorizations_attributes: [{category: site1.categories.find_by!(slug: "category3_1_1"), order: 1}],
    )
    i += 1
    post = site1.posts.create!(
      title: "Post #{i}",
      body: paginate_body,
      thumbnail: Rails.root.join("db/data/thumbnail.jpg").open,
      published_at: Time.current,
      categorizations_attributes: [{category: site1.categories.find_by!(slug: "category3_1_2"), order: 1}],
    )
    i += 1
    post = site1.posts.create!(
      title: "Post #{i}",
      body: paginate_body,
      thumbnail: Rails.root.join("db/data/thumbnail.jpg").open,
      published_at: Time.current,
      categorizations_attributes: [
        {category: site1.categories.find_by!(slug: "category3_1_3"), order: 1},
        {category: site1.categories.find_by!(slug: "category3_1_4"), order: 2},
      ],
    )
    i += 1
    post = site1.posts.create!(
      title: "Post #{i}",
      body: paginate_body,
      thumbnail: Rails.root.join("db/data/thumbnail.jpg").open,
      published_at: Time.current,
      categorizations_attributes: [{category: site1.categories.find_by!(slug: "category3_2"), order: 1}],
    )
    i += 1
    post = site1.posts.create!(
      title: "Post #{i}",
      body: paginate_body,
      thumbnail: Rails.root.join("db/data/thumbnail.jpg").open,
      published_at: Time.current,
      categorizations_attributes: [{category: site1.categories.find_by!(slug: "category3_3"), order: 1}],
    )
  end
end
