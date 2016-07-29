FactoryGirl.define do
  factory :participant do
    sequence(:name) {|n| "Author #{n}" }
    summary { "#{name}: Awesome summary" }
    description { "#{name}: Awesome description" }

    trait :whatever do
      site
    end

    trait :with_photo do
      photo { Rails.root.join("test/fixtures/images/face.png").open }
    end

    trait :with_posts do
      after :create do |participant, _evaluator|
        post = create(:post, :whatever, site: participant.site)
        post.credits << build(:credit, :whatever, site: participant.site, participant: participant)
      end
    end
  end
end
