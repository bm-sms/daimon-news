FactoryGirl.define do
  factory :link do
    sequence(:text) {|i| "Url #{i}" }
    sequence(:url) {|i| "/url#{i}" }
    sequence(:order)
  end
end
