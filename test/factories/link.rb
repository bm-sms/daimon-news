FactoryGirl.define do
  factory :link do
    text "text"
    url "http://example.com/"
    sequence(:order)
  end
end
