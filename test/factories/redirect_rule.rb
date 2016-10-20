FactoryGirl.define do
  factory :redirect_rule do
    trait :whatever do
      site

      sequence(:request_path) {|i| "/req-#{i}" }
      sequence(:destination)  {|i| "/dest-#{i}" }
    end
  end
end
