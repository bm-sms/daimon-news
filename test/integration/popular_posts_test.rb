require "test_helper"

class PopularPostTest < ActionDispatch::IntegrationTest
  setup do
    @site = create(:site, fqdn: "127.0.0.1", analytics_viewid: "118235291", ranking_dimension: "ga:pagePath", ranking_size: 5)
    switch_domain(@site.fqdn)

    create(:post, :whatever, public_id: 1001, title: "5. Ruby", published_at: 15.days.ago, site: @site)
    create(:post, :whatever, public_id: 1002, title: "6. Java", published_at: 15.days.ago, site: @site)
    create(:post, :whatever, :unpublished, public_id: 1003, title: "PHP is unpublished", site: @site)
    create(:post, :whatever, public_id: 1004, title: "3. Python", published_at: 15.days.ago, site: @site)
    create(:post, :whatever, public_id: 1005, title: "2. Perl", published_at: 15.days.ago, site: @site)
    create(:post, :whatever, public_id: 1006, title: "JavaScript is few page views", published_at: 15.days.ago, site: @site)
    create(:post, :whatever, public_id: 1007, title: "Swift is new post", published_at: 3.days.ago, site: @site)
    create(:post, :whatever, public_id: 1008, title: "1. Scala", published_at: 15.days.ago, site: @site)
    create(:post, :whatever, public_id: 1009, title: "C++ has no pageview 2 weeks ago", published_at: 15.days.ago, site: @site)
    create(:post, :whatever, public_id: 1010, title: "4. C#", published_at: 15.days.ago, site: @site)
    create(:post, :whatever, public_id: 1011, title: "Haskell is other site post", published_at: 15.days.ago, site: create(:site))

    load "scripts/build_popular_posts.rb"
    visit "/"
  end

  test "The order is correct" do
    within ".popular-articles" do
      names = find_all("li").map do |li|
        li.first(".article-summary__title").text
      end
      assert_equal(["1. Scala", "2. Perl", "3. Python", "4. C#", "5. Ruby"], names)
    end
  end

  test "New articles are not displayed" do
    within ".popular-articles" do
      assert_not(page.has_css?("li", text: "Swift is new post"))
    end
  end

  test "Article of 0 pageview two weeks ago are not displayed" do
    within ".popular-articles" do
      assert_not(page.has_css?("li", text: "C++ has no pageview 2 weeks ago"))
    end
  end

  test "an unpublished artcile is not displayed" do
    within ".popular-articles" do
      assert_not(page.has_css?("li", text: "PHP is unpublished"))
    end
  end

  test "Articles with few page views are not displayed" do
    within ".popular-articles" do
      assert_not(page.has_css?("li", text: "JavaScript is few page views"))
    end
  end

  test "Articles that exceed the ranking size are not displayed" do
    within ".popular-articles" do
      assert_not(page.has_css?("li", text: "6. Java"))
    end
  end

  test "Articles of other sites are not displayed" do
    within ".popular-articles" do
      assert_not(page.has_css?("li", text: "Haskell is other site post"))
    end
  end
end
