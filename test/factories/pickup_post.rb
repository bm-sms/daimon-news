FactoryGirl.define do
  factory :pickup_post do
    trait :whatever do
      site
      sequence(:order)

      post { create(:post, :whatever, site: site) }
    end
  end
end
