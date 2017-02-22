require "test_helper"

class ApiTest < ActionDispatch::IntegrationTest
  sub_test_case "posts" do
    setup do
      @site     = create(:site)
      @category = create(:category, site: @site)
      @serial   = create(:serial,   site: @site)
      @post     = create(:post,     site: @site, serial: @serial, categorizations_attributes: [{category: @category, order: 1}])

      create(:post, site: @site, categorizations_attributes: [{category: @category, order: 1}])
      create(:post, site: @site, serial: @serial, categorizations_attributes: [{category: create(:category, site: @site), order: 1}])
      create(:post, site: @site, serial: create(:serial, site: @site), categorizations_attributes: [category: create(:category, site: @site), order: 1])
      host!(@site.fqdn)
    end

    test "category and serial filter should be applied to /api/posts" do
      filter = {
        category_slug: @category.slug,
        serial_id:     @serial.id
      }

      get("/api/#{@site.fqdn}/posts?#{{filter: filter}.to_query}")

      result = JSON.parse(response.body, symbolize_names: true)

      assert_equal(1, result.dig(:data).count)
      assert_equal(@post.id, result.dig(:data, 0, :id).to_i)
    end
  end

  sub_test_case "top fixed posts" do
    setup do
      @site = create(:site)
      create(:top_fixed_post, :whatever, order: 1, site: @site, post: create(:post, :whatever, title: "Ruby is fixed", site: @site))
      create(:top_fixed_post, :whatever, order: 2, site: @site, post: create(:post, :whatever, :unpublished, title: "Java is unpublished", site: @site))
      host!(@site.fqdn)
    end

    test "show only published post" do
      get("/api/#{@site.fqdn}/top_fixed_posts")

      result = JSON.parse(response.body, symbolize_names: true)

      assert_equal(1, result.dig(:data).count)
      assert_equal("Ruby is fixed", result.dig(:data, 0, :attributes, :title))
    end
  end
end
