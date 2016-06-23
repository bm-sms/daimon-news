require "test_helper"

class SerialTest < ActionDispatch::IntegrationTest
  setup do
    @site = create(:site)
    @serials = create_list(:serial, 3, :with_posts, :with_unpublished_posts, site: @site)
    create(:serial, :with_unpublished_posts, title: "Unpublished serial", site: @site)

    switch_domain(@site.fqdn)
  end

  sub_test_case "/serials" do
    test "page title" do
      visit "/serials"

      assert_equal("すべての連載 | #{@site.name}", title)
    end

    test "page title with pagination" do
      create_list(:serial, 50, :with_posts, site: @site)

      visit "/serials?page=2"

      assert_equal("すべての連載 (26〜50/#{Serial.published.count}件) | #{@site.name}", title)
    end

    test "serial titles" do
      visit "/serials"

      serial_titles = find_all ".serial-summary__title"
      assert_equal(@serials.map(&:title).reverse, serial_titles.map(&:text))
    end

    test "number of posts" do
      visit "/serials"

      number_of_posts = find_all ".number-of-posts"
      assert_equal(["記事数：1", "記事数：1", "記事数：1"], number_of_posts.map(&:text))
    end
  end

  sub_test_case "/serials/:id" do
    test "page title" do
      visit "/serials"

      click_on @serials.last.title

      assert_equal("#{@serials.last.title} | #{@site.name}", title)
    end

    test "serial title" do
      visit "/serials"

      click_on @serials.last.title

      title = find ".serial-content__title"
      assert_equal(@serials.last.title, title.text)
    end
  end
end
