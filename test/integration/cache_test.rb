require "test_helper"

class EditorTest < ActionDispatch::IntegrationTest
  setup do
    @site = create(:site)
    switch_domain(@site.fqdn)
  end

  sub_test_case "PostCache" do
    setup do
      @post = create(:post, :whatever, site: @site, public_id: 1000, title: "before", updated_at: '2017/01/01 10:00:00')
    end

    test "cache enabled" do
      # caching
      visit "/#{@post.public_id}"

      @post.update_column(:title, 'changed') # no update updated_at

      visit "/#{@post.public_id}"

      assert(page.has_css?("h1.post__title", text: "before"))
    end

    test "cache clear" do
      # caching
      visit "/#{@post.public_id}"

      @post.title = 'changed'
      @post.save! # update updated_at

      visit "/#{@post.public_id}"

      assert(page.has_css?("h1.post__title", text: "changed"))
    end

  end
end
