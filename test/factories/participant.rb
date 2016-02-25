FactoryGirl.define do
  factory :participant do
    sequence(:name) {|n| "Author #{n}" }
    description { "#{name} description\n" }

    trait :with_photo do
      photo { Rails.root.join('test/fixtures/images/face.png').open }
    end
  end
end
