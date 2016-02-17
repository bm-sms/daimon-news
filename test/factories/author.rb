FactoryGirl.define do
  factory :author do
    sequence(:name) {|n| "Author #{n}" }
    description { "#{name} description\n" }

    site
  end
end
