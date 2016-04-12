FactoryGirl.define do
  factory :series do
    sequence(:title) {|n| "Series #{n}" }
    sequence(:slug) {|n| "series#{n}" }
    description { "#{title} description\n" }
  end
end
