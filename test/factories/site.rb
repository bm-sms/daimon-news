FactoryGirl.define do
  factory :site do
    sequence(:name) {|n| "daimon-news#{n}" }
    sequence(:fqdn) {|n| "daimon-news-#{n}.example.com" }
    opened true
    public_participant_page_enabled true
    multiple_categories_enabled true
  end
end
