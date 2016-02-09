FactoryGirl.define do
  factory :site do
    sequence :name do |n|
      "daimon-news#{n}"
    end
    fqdn { "#{name}.example.com" }
  end
end
