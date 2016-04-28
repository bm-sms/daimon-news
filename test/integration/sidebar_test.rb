require "test_helper"

class SidebarTest < ActionDispatch::IntegrationTest
  setup do
    setup_groonga_database
    @post = create(:post, :whatever, body: <<~EOS.encode(crlf_newline: true))
      # hi
      contents
    EOS

    switch_domain(@post.site.fqdn)
    @indexer = PostIndexer.new
  end

  teardown do
    teardown_groonga_database
  end

  test "top page does not display recent posts on sidebar" do
    visit "/"

    within ".wrappable__content.promotions" do
      assert(page.has_no_selector?("h2", text: "新着記事"))
    end
  end

  test "pages except top page display recent posts on sidebar" do
    visit "/#{@post.public_id}"

    within ".wrappable__content.promotions" do
      assert(page.has_selector?("h2", text: "新着記事"))
    end

    visit "/category/#{@post.category.slug}"

    within ".wrappable__content.promotions" do
      assert(page.has_selector?("h2", text: "新着記事"))
    end
  end

  test "search result page display recent posts on sidebar" do
    visit "/"
    fill_in "query[keywords]", with: "contents"
    click_on "検索"

    within ".wrappable__content.promotions" do
      assert(page.has_selector?("h2", text: "新着記事"))
    end
  end
end
