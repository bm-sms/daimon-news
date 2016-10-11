FactoryGirl.define do
  factory :redirect_rule do
    association :site, factory: :site

    request_path "/1"
    destination "/2"

    factory :redirect_rule_request_path_has_fragment_string do
      request_path "/1#123"
    end

    factory :redirect_rule_with_urlencoded_request_path do
      request_path "/%E6%97%A5%E6%9C%AC%E8%AA%9E"
    end

    factory :redirect_rule_absolute_request_path do
      request_path "https://test.com"
    end

    factory :redirect_rule_request_path_with_query_string do
      request_path "/1?page=1"
    end

    factory :redirect_rule_punycode_destination do
      destination "http://xn--wgv71a119e.jp/%E6%97%A5%E6%9C%AC%E8%AA%9E"
    end

    factory :redirect_rule_request_equal_destination do
      request_path "/1"
      destination "/1"
    end
  end
end
