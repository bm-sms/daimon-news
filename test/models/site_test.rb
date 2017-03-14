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
      @post = create(:post, :whatever, :with_credit, site: @site)
      Tempfile.open do |file|
        @site.images.create!(image: file)
      end
      create(:serial, site: @site)

      create(:fixed_page, site: @site)
      create(:link,       site: @site)
      create(:membership, site: @site)
      create(:redirect_rule, :whatever, site: @site)

      create(:pickup_post,    :whatever, post: @post, site: @site)
      create(:popular_post,   :whatever, post: @post, site: @site)
      create(:top_fixed_post, :whatever, post: @post, site: @site)
    end

    test "destroy site" do
      assert_equal(1, Site.count)
      assert_equal(1, Post.count)
      assert_equal(1, Image.count)
      assert_equal(1, Serial.count)
      assert_equal(1, Category.count)
      assert_equal(1, CreditRole.count)
      assert_equal(1, Participant.count)

      assert_equal(1, FixedPage.count)
      assert_equal(1, Link.count)
      assert_equal(1, Membership.count)
      assert_equal(1, RedirectRule.count)

      assert_equal(1, PickupPost.count)
      assert_equal(1, PopularPost.count)
      assert_equal(1, TopFixedPost.count)

      @site.reload
      @site.destroy

      assert_equal(0, Site.count)
      assert_equal(0, Post.count)
      assert_equal(0, Image.count)
      assert_equal(0, Serial.count)
      assert_equal(0, Category.count)
      assert_equal(0, CreditRole.count)
      assert_equal(0, Participant.count)

      assert_equal(0, FixedPage.count)
      assert_equal(0, Link.count)
      assert_equal(0, Membership.count)
      assert_equal(0, RedirectRule.count)

      assert_equal(0, PickupPost.count)
      assert_equal(0, PopularPost.count)
      assert_equal(0, TopFixedPost.count)
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
      "%0x" => ["This is a %0x", false],
      "%" => ["This is a % test", true],
      "% at the end of line" => ["This is a %", true]
    )
    def test_validate(data)
      format, expected = data
      site = build(:site, category_title_format: format)
      assert_equal(expected, site.valid?)
    end
  end

  sub_test_case "Custome style" do
    test "with #base_hue" do
      site = create(:site, base_hue: 300)

      assert_valid_custom_css(site)
    end

    test "without #base_hue" do
      site = create(:site, base_hue: nil)

      assert_nil(site.custom_hue_css_url)
    end

    test "update #base_hue" do
      site = create(:site, base_hue: nil)

      assert_nil(site.custom_hue_css_url)
      site.update!(base_hue: 200)
      assert_valid_custom_css(site)
      assert_custom_css_changed(site) do
        site.update!(base_hue: 300)
      end
      assert_valid_custom_css(site)
      site.update!(base_hue: nil)
      assert_nil(site.custom_hue_css_url)
    end

    def assert_valid_custom_css(site)
      assert_match(/\.css\z/, site.custom_hue_css_url)
      assert_equal("text/css", site.custom_hue_css.content_type)
    end

    def assert_custom_css_changed(site)
      before_url = site.custom_hue_css_url
      before_content = site.custom_hue_css.read
      yield
      after_url = site.custom_hue_css_url
      after_content = site.custom_hue_css.read

      assert_not_equal(before_url, after_url)
      assert_not_equal(before_content, after_content)
    end
  end

  sub_test_case "#posted_root_categories" do
    setup do
      @site = create(:site)
      @root_category_with_grandchild = create(:category, site: @site)
      @root_category_without_child = create(:category, site: @site)
      @grandchild_category = create(:category, site: @site, parent: create(:category, site: @site, parent: @root_category_with_grandchild))

      create(:post, :whatever) # create another site has a category and a post
    end

    test "when the site has no posted categories" do
      assert_equal([], @site.posted_root_categories.pluck(:id))
    end

    test "when the site has a posted category which doesn't have any child" do
      create(:post, site: @site, categories: [@root_category_without_child])

      assert_equal([@root_category_without_child.id], @site.posted_root_categories.pluck(:id))
    end

    test "when the site has a root category which has posted grandchild" do
      create(:post, site: @site, categories: [@grandchild_category])

      assert_equal([@root_category_with_grandchild.id], @site.posted_root_categories.pluck(:id))
    end
  end
end
