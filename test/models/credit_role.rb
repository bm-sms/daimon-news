require "test_helper"

class CreditRoleTest < ActiveSupport::TestCase
  setup do
    @default_locale = I18n.locale
    I18n.locale = :ja
    @site = create(:site)
  end

  teardown do
    I18n.locale = @default_locale
  end

  sub_test_case "order" do
    test "unique" do
      create(:credit_role, site: @site, order: 1)
      credit_role = build(:credit_role, site: @site, order: 1)
      assert_false(credit_role.valid?)
      assert_equal(["はすでに存在します"], credit_role.errors[:order])
    end

    test "not integer" do
      credit_role = build(:credit_role, site: @site, order: "x")
      assert_false(credit_role.valid?)
      assert_equal(["は数値で入力してください"], credit_role.errors[:order])
    end
  end
end
