FactoryGirl.define do
  factory :fixed_page do
    sequence(:title) {|n| "title #{n}" }
    body "body"
    sequence(:slug) {|n| "slug#{n}" }
  end
end
