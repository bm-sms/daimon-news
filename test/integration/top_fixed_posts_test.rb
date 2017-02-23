require "test_helper"

class TopFixedPostTest < ActionDispatch::IntegrationTest
  setup do
    @site = create(:site, fqdn: "127.0.0.1")
    switch_domain(@site.fqdn)

    create(:post, :whatever, title: "PHP is the newest", published_at: "2017/01/01 10:00:00", site: @site)
    create(:top_fixed_post, :whatever, order: 1, site: @site, post: create(:post, :whatever, title: "Ruby is fixed", published_at: "2016/12/01 10:00:00", site: @site))
    create(:top_fixed_post, :whatever, order: 2, site: @site, post: create(:post, :whatever, :unpublished, title: "Java is unpublished", site: @site))
  end

  test "fixed articles are displayed first" do
    visit "/"
    within ".press-articles" do
      assert_equal(find_all(".article-summary__title").first.text, "Ruby is fixed")
    end
  end

  test "show only published post" do
    visit "/"
    within ".press-articles" do
      assert page.has_content?("PHP is the newest")
      assert page.has_content?("Ruby is fixed")
      assert page.has_no_content?("Java is unpublished")
    end
  end
end
