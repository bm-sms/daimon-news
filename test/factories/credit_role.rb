FactoryGirl.define do
  factory :credit_role do
    sequence(:name) {|n| "Name #{n}" }
    sequence(:order)
  end
end
