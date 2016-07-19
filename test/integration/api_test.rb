require "test_helper"

class ApiTest < ActionDispatch::IntegrationTest
  setup do
    @site     = create(:site)
    @category = create(:category, site: @site)
    @serial   = create(:serial,   site: @site)
    @post     = create(:post,     site: @site, category: @category, serial: @serial)
    create(:post, site: @site, category: @category)
    create(:post, site: @site, category: create(:category, site: @site), serial: @serial)
    create(:post, site: @site, category: create(:category, site: @site), serial: create(:serial, site: @site))
  end

  test "category and serial filter should be applied to /api/posts" do
    filter = {
      category_slug: @category.slug,
      serial_id:     @serial.id
    }

    get "/api/#{@site.fqdn}/posts?#{{filter: filter}.to_query}"

    result = JSON.parse(response.body, symbolize_names: true)

    assert_equal 1, result.dig(:data).count
    assert_equal @post.id, result.dig(:data, 0, :id).to_i
  end
end