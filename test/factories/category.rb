FactoryGirl.define do
  factory :category do
    sequence :name do |n|
      "category#{n}"
    end
    description { "#{name} description\n" }

    slug { name }
    sequence :order do |n|
      n
    end
  end
end
