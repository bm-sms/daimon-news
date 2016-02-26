class PostRouteTest < ActionDispatch::IntegrationTest
  def setup
    @site = create(:site)
    @category = create(:category, site: @site)
    @post = create(:post, :with_pages, site: @site, category: @category)
    https!
    host! @site.fqdn
  end

  def test_first_page
    get "/#{@post.public_id}"
    assert_response(:success)
  end

  def test_redirect_to_2nd_page
    get "/#{@post.public_id}/2"
    assert_response(:moved_permanently)
    assert_redirected_to("/#{@post.public_id}?page=2")
  end
end
