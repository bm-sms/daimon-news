DEFAULT_PASSWORD = 'passw0rd'

FactoryGirl.define do
  factory :user do
    sequence(:email) {|n| "#{n}@example.com" }
    password DEFAULT_PASSWORD

    trait :admin do
      admin true
    end
  end
end
