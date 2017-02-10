FactoryGirl.define do
  factory :top_fixed_post do
    trait :whatever do
      site
      sequence(:order)

      post { create(:post, :whatever, site: site) }
    end
  end
end
