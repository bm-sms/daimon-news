FactoryGirl.define do
  factory :credit do
    trait :whatever do
      transient do
        site nil
      end

      sequence(:order)

      participant { create(:participant, site: site) }
      role { create(:credit_role, site: site) }
    end
  end
end
