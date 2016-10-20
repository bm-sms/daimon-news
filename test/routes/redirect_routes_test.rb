require "test_helper"

class RedirectRoutesTest < ActionDispatch::IntegrationTest
  def setup
    @site = create(:site, fqdn: "127.0.0.1")
    @category = create(:category, site: @site)
    @post = create(:post, :with_pages, site: @site, categorizations_attributes: [{category: @category, order: 1}])
    @redirect_rule = create(:redirect_rule, site: @site, request_path: "/page1", destination: "/#{@post.public_id}?page=1")
    https!
    host!(@site.fqdn)
  end

  def test_redirect
    get("/page1")
    assert_response(:moved_permanently)
    assert_redirected_to("/#{@post.public_id}?page=1")
  end
end
