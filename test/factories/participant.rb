FactoryGirl.define do
  factory :participant do
    sequence(:name) {|n| "Author #{n}" }
    summary { "#{name}: Awesome summary" }

    trait :whatever do
      site
    end

    trait :with_photo do
      photo { Rails.root.join("test/fixtures/images/face.png").open }
    end
  end
end
