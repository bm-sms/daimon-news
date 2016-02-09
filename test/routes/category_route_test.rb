class CategoryRouteTest < ActionDispatch::IntegrationTest
  def setup
    @site = create(:site)
    @category = create(:category, site_id: @site.id)
  end

  def teardown
    @site.destroy
  end

  def test_first_page
    get "/category/category1"
    assert_response(:success)
  end

  def test_redirect_to_2nd_page
    get "/category/category1/page/2"
    assert_response(:moved_permanently)
    assert_redirected_to("/category/category1?page=2")
  end
end
