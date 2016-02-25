FactoryGirl.define do
  factory :site do
    sequence(:name) {|n| "daimon-news#{n}" }
    sequence(:fqdn) {|n| "daimon-news-#{n}.example.com" }
    opened true
  end
end
