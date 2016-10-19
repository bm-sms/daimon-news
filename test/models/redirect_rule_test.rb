require "test_helper"

class RedirectRuleTest < ActiveSupport::TestCase
  setup do
    @default_locale, I18n.locale = I18n.locale, :ja
  end

  teardown do
    I18n.locale = @default_locale
  end

  test "create" do
    assert build(:redirect_rule, :whatever, request_path: "/1", destination: "/2").valid?
  end

  sub_test_case "before_validation" do
    test "request_path" do
      rule = build(:redirect_rule, :whatever, request_path: "/%E6%97%A5%E6%9C%AC%E8%AA%9E")
      assert rule.valid?
      assert_equal rule.request_path, "/日本語"
    end

    test "destination" do
      rule = build(:redirect_rule, :whatever, destination: "http://xn--wgv71a119e.jp/%E6%97%A5%E6%9C%AC%E8%AA%9E")
      assert rule.valid?
      assert_equal rule.destination, "http://日本語.jp/日本語"
    end
  end

  sub_test_case "validation" do
    test "absolute path for request_path is invalid" do
      rule = build(:redirect_rule, :whatever, request_path: "http://example.com")
      assert rule.invalid?
      assert_equal rule.errors.messages[:request_path], ["/ から始まるパスのみ設定できます"]
    end

    test "request path with fragment string is invalid" do
      rule = build(:redirect_rule, :whatever, request_path: "/1#hoge")
      assert rule.invalid?
      assert_equal rule.errors.messages[:request_path], ["フラグメント識別子は含めることができません"]
    end

    test "request path with query string is invalid" do
      rule = build(:redirect_rule, :whatever, request_path: "/1?page=1")
      assert rule.invalid?
      assert_equal rule.errors.messages[:request_path], ["クエリパラメーターは含めることができません"]
    end

    test "request path == destination is invalid" do
      rule = build(:redirect_rule, :whatever, request_path: "/1", destination: "/1")
      assert rule.invalid?
      assert_equal rule.errors.messages[:request_path], ["リダイレクト元とリダイレクト先は同じにできません"]
    end

    test "redirect loop is invalid" do
      site = create(:site)
      create(:redirect_rule, request_path: "/a", destination: "/b", site: site)

      loop_rule = build(:redirect_rule, request_path: "/b", destination: "/a", site: site)
      loop_rule_for_other_site = create(:redirect_rule, :whatever, request_path: "/b", destination: "/a")

      assert loop_rule.invalid?
      assert_equal loop_rule.errors.messages[:destination], ["リダイレクトループが発生する設定は追加できません"]
      assert loop_rule_for_other_site.valid?
    end
  end
end
