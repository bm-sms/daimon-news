require "test_helper"

class SerialModelTest < ActiveSupport::TestCase
  setup do
    @site = create(:site)
  end

  sub_test_case "published" do
    test "serial without posts" do
      create_list(:serial, 3, site: @site)
      assert_equal(0, Serial.published.count)
    end

    test "serial with published posts" do
      create_list(:serial, 3, :with_posts, site: @site)
      assert_equal(3, Serial.published.count)
    end

    test "serial with unpublished posts" do
      create_list(:serial, 3, :with_unpublished_posts, site: @site)
      assert_equal(0, Serial.published.count)
    end

    test "serial with published and unpublished posts" do
      create_list(:serial, 3, :with_posts, :with_unpublished_posts, site: @site)
      assert_equal(3, Serial.published.count)
    end
  end
end
