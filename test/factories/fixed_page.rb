FactoryGirl.define do
  factory :fixed_page do
    sequence(:title) {|n| "Page #{n}" }
    body { "#{title} body\n" }
    sequence(:slug) {|n| "page#{n}" }
  end
end
