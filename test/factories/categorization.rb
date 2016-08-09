FactoryGirl.define do
  factory :categorization do
    trait :whatever do
      transient do
        site nil
      end

      sequence(:order)

      category { create(:category, site: site) }
    end
  end
end
