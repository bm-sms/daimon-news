require "test_helper"

class RedirectRuleTest < ActiveSupport::TestCase
  setup do
    @default_locale = I18n.locale
    I18n.locale = :ja
    @site = create(:site)
  end

  test "create" do
    assert build(:redirect_rule).valid?
  end

  sub_test_case "before_validation" do
    test "request_path" do
      assert build(:redirect_rule_with_urlencoded_request_path).valid?
    end

    test "destination" do
      assert build(:redirect_rule_punycode_destination).valid?
    end
  end

  sub_test_case "validation" do
    test "relative absolute path is invalid" do
      rule = build(:redirect_rule_absolute_request_path)
      assert rule.invalid?
    end

    test "request path with fragment string is invalid" do
      rule = build(:redirect_rule_request_path_has_fragment_string)
      assert rule.invalid?
    end

    test "request path with query string is invalid" do
      rule = build(:redirect_rule_request_path_with_query_string)
      assert rule.invalid?
    end
    test "redirect rule that has same value is invalid" do
      rule = build(:redirect_rule_request_equal_destination)
      assert rule.invalid?
    end

    test "redirect loop is invalid" do
      rule = create(:redirect_rule)
      loop_rule = RedirectRule.create(site: rule.site, request_path: rule.destination, destination: rule.request_path)
      assert loop_rule.invalid?
    end
  end
end
