require "test_helper"

class SiteTest < ActiveSupport::TestCase
  setup do
    @default_locale = I18n.locale
    I18n.locale = :ja
  end

  teardown do
    I18n.locale = @default_locale
  end

  sub_test_case "relation" do
    setup do
      @site = create(:site)
      @post = create(:post, :whatever, site: @site)
      Tempfile.open do |file|
        @site.images.create!(image: file)
      end
    end

    test "destroy site" do
      assert_equal(1, Site.count)
      assert_equal(1, Category.count)
      assert_equal(1, Post.count)
      assert_equal(1, Image.count)
      @site.destroy
      assert_equal(0, Site.count)
      assert_equal(0, Category.count)
      assert_equal(0, Post.count)
      assert_equal(0, Image.count)
    end
  end

  sub_test_case "name" do
    test "null" do
      site = Site.new
      assert_false(site.valid?)
      assert_equal(["を入力してください"], site.errors[:name])
    end

    test "blank" do
      site = Site.new(name: "")
      assert_false(site.valid?)
      assert_equal(["を入力してください"], site.errors[:name])
    end
  end

  sub_test_case "fqdn" do
    test "blank" do
      site = Site.new(name: "site1", fqdn: "")
      assert_false(site.valid?)
      assert_equal(["を入力してください"], site.errors[:fqdn])
    end

    test "unique" do
      fqdn = "exapmle.com"
      Site.create!(name: "site1", fqdn: fqdn)
      site = Site.new(name: "site2", fqdn: fqdn)
      assert_false(site.valid?)
      assert_equal(["はすでに存在します"], site.errors[:fqdn])
    end
  end

  sub_test_case "category_title_format" do
    test "null" do
      site = build(:site)
      assert_true(site.valid?)
    end

    test "blank" do
      site = build(:site, category_title_format: "")
      assert_true(site.valid?)
    end

    data(
      "without format" => ["This is a title", true],
      "%{category_name}" => ["This is a %{category_name}", true],
      "%{title}" => ["This is a %{title}", false],
      "multiple %{category_name}" => ["This is a %{category_name} and %{category_name}", true],
      "%{category_name} and %{title}" => ["This is a %{category_name} | %{title}", false],
      "%%" => ["This is a %%", true],
      "%s" => ["This is a %s", false],
      "%d" => ["This is a %d", false],
      "%0x" => ["This is a %0x", false]
    )
    def test_validate(data)
      format, expected = data
      site = build(:site, category_title_format: format)
      assert_equal(expected, site.valid?)
    end
  end
end
