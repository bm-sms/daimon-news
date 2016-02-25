FactoryGirl.define do
  factory :credit do
    trait :whatever do
      transient do
        site nil
      end

      participant { create(:participant, site: site) }
      role { create(:credit_role, site: site) }
    end
  end
end
