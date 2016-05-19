require "test_helper"

class PostSearcherTest < ActiveSupport::TestCase
  setup do
    setup_groonga_database
    @site = create(:site)
    @indexer = PostIndexer.new
  end

  teardown do
    teardown_groonga_database
  end

  test "full-width space should be delimiter" do
    post = create_post(
      site: @site,
      title: "記事のタイトル",
      body: "...記事の内容..."
    )
    keywords = "タイトル　内容"

    query = Query.new(keywords: keywords, site_id: @site.id)
    searched_posts = PostSearcher.new.search(query)

    assert_equal(["記事のタイトル"], searched_posts.map(&:title))
  end

  private

  def create_post(*attributes)
    post = create(:post, :whatever, :with_credit, *attributes)
    @indexer.add(post)
    post
  end
end
