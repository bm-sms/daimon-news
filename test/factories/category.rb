FactoryGirl.define do
  factory :category do
    transient do
      categories []
    end

    sequence(:name) {|n| "Category #{n}" }
    sequence(:slug) {|n| "category#{n}" }
    description { "#{name} description\n" }

    sequence(:order)
  end
end
