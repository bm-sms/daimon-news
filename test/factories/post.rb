FactoryGirl.define do
  factory :post do
    title "title"
    body "body"
    thumbnail { Rails.root.join("test/fixtures/images/thumbnail.jpg").open }
    published_at { DateTime.parse("2016-01-01") }

    trait :whatever do
      site
      after :create do |post, _evaluator|
        post.categorizations << build(:categorization, :whatever, site: post.site)
        post.save!
        post.reload
      end
    end

    trait :unpublished do
      published_at { nil }
    end

    trait :with_pages do
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

    trait :with_credit do
      after :create do |post, evaluator|
        post.credits << build(:credit, :whatever, site: post.site)
      end
    end
  end
end
