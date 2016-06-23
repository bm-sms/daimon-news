after "development:posts" do
  site1 = Site.find_by!(name: "site1")

  posts = site1.posts.published.order_by_recently.cycle

  26.times do |i|
    serial = site1.serials.create!(
      title: "Serial#{i}",
      description: "Serial",
      thumbnail: Rails.root.join("db/data/thumbnail.jpg").open
    )
    3.times do
      posts.next.update!(serial: serial)
    end
  end

  serial = site1.serials.last
  21.times do
    posts.next.update!(serial: serial)
  end
end
