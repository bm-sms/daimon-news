FactoryGirl.define do
  factory :serial do
    sequence(:title) {|n| "Serial #{n}" }
    description { "#{title} description\n" }
    thumbnail { Rails.root.join("test/fixtures/images/thumbnail.jpg").open }

    trait :with_posts do
      before :create do |serial, _evaluator|
        serial.posts << create(:post, :whatever, site: serial.site)
      end
    end

    trait :with_unpublished_posts do
      before :create do |serial, _evaluator|
        serial.posts << create(:post, :whatever, :unpublished, site: serial.site)
      end
    end
  end
end
