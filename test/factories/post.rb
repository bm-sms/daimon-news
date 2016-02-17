FactoryGirl.define do
  factory :post do
    title "title"
    body "body"
    published_at "2016-01-01 00:00:00"
    site
    category { create(:category, site: site) }
  end

  factory :post_with_pages, parent: :post do
    title "title"
    body <<~BODY
      # title

      body

      <!--nextpage-->

      ## title 2

      hello

      <!--nextpage-->

      ## title 3

      world
    BODY
  end

  factory :post_with_author, parent: :post do
    author
  end
end
