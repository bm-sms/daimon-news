class CategoryRouteTest < ActionDispatch::IntegrationTest
  def test_redirect_to_2nd_page
    get "/category/category1/page/2"
    assert_response(:moved_permanently)
    assert_redirected_to("/category/category1?page=2")
  end
end
