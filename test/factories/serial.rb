FactoryGirl.define do
  factory :serial do
    sequence(:title) {|n| "Serial #{n}" }
    sequence(:slug) {|n| "serial#{n}" }
    description { "#{title} description\n" }
  end
end
