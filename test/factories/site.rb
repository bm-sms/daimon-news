FactoryGirl.define do
  factory :site do
    sequence(:name) {|n| "daimon-news#{n}" }
    sequence(:fqdn) {|n| "daimon-news-#{n}.example.com" }
    opened true
    public_participant_page_enabled true
    hierarchical_categories_enabled true

    trait :resize_thumb do
      resize_thumb true
    end
  end
end
