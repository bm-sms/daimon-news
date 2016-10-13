require "test_helper"

class RedirectRuleTest < ActiveSupport::TestCase
  setup do
    @default_locale = I18n.locale
    I18n.locale = :ja
    @site = create(:site)
  end

  teardown do
    I18n.locale = @default_locale
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
      assert_equal rule.errors.messages[:request_path], ["/ から始まる相対パスのみ設定できます"]
    end

    test "request path with fragment string is invalid" do
      rule = build(:redirect_rule_request_path_has_fragment_string)
      assert rule.invalid?
      assert_equal rule.errors.messages[:request_path], ["フラグメント識別子は含めることができません"]
    end

    test "request path with query string is invalid" do
      rule = build(:redirect_rule_request_path_with_query_string)
      assert rule.invalid?
      assert_equal rule.errors.messages[:request_path], ["クエリパラメーターは含めることができません"]
    end
    test "redirect rule that has same value is invalid" do
      rule = build(:redirect_rule_request_equal_destination)
      assert rule.invalid?
      assert_equal rule.errors.messages[:request_path], ["リダイレクト元とリダイレクト先は同じにできません"]
    end

    test "redirect loop is invalid" do
      rule = create(:redirect_rule)
      loop_rule = RedirectRule.create(site_id: rule.site.id, request_path: rule.destination, destination: rule.request_path)
      assert loop_rule.invalid?
      assert_equal loop_rule.errors.messages[:destination], ["リダイレクトループが発生する設定は追加できません"]
    end
  end
end
