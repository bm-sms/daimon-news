FactoryGirl.define do
  factory :popular_post do
    trait :whatever do
      site
      sequence(:rank)

      post { create(:post, :whatever, site: site) }
    end
  end
end
