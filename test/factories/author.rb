FactoryGirl.define do
  factory :author do
    sequence(:name) {|n| "Author #{n}" }
    description { "#{name} description\n" }

    site
  end

  factory :author_with_photo, parent: :author do
    photo { Rack::Test::UploadedFile.new(Rails.root + "test/fixtures/images/face.png", "image/png") }
  end
end
