FactoryGirl.define do
  factory :post do
    title "title"
    body "body"
    thumbnail { open(Rails.root.join('test/fixtures/images/thumbnail.jpg')) }
    published_at "2016-01-01 00:00:00"
    category { create(:category, site: site) }

    trait :whatever do
      site
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
