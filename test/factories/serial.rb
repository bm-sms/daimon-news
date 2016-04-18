FactoryGirl.define do
  factory :serial do
    sequence(:title) {|n| "Serial #{n}" }
    sequence(:slug) {|n| "serial#{n}" }
    description { "#{title} description\n" }

    trait :with_posts do
      after :create do |serial, _evaluator|
        serial.posts << build(:post, :whatever, site: serial.site)
      end
    end
  end
end
