require "test_helper"

class SerialTest < ActionDispatch::IntegrationTest
  setup do
    @site = create(:site)
    1.upto(3) do |i|
      create(:serial, :with_posts, title: "Serial #{i}", site: @site)
    end

    switch_domain(@site.fqdn)
  end

  sub_test_case "/serials" do
    test "page title" do
      visit "/serials"

      assert_equal("すべての連載 | #{@site.name}", title)
    end

    test "serial titles" do
      visit "/serials"

      serial_titles = find_all ".serial-summary__title"
      assert_equal(["Serial 3", "Serial 2", "Serial 1"], serial_titles.map(&:text))
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

      click_on "Serial 3"

      assert_equal("Serial 3 | #{@site.name}", title)
    end

    test "serial title" do
      visit "/serials"

      click_on "Serial 3"

      title = find ".serial-content__title"
      assert_equal("Serial 3", title.text)
    end
  end
end
