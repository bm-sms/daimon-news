FactoryGirl.define do
  factory :category do
    sequence(:name) {|n| "Category #{n}" }
    sequence(:slug) {|n| "category#{n}" }
    description { "#{name} description\n" }

    sequence(:order)
  end
end
