require "test_helper"

class PageNotFoundTest < ActionDispatch::IntegrationTest
  setup do
    Rails.application.env_config["action_dispatch.show_detailed_exceptions"] = false
    Rails.application.env_config["action_dispatch.show_exceptions"] = true
  end

  sub_test_case "posts test" do
    setup do
      @site = create(:site)
      @posts = create_list(:post, 50, :whatever, site: @site)
      switch_domain(@site.fqdn)
    end

    data(
      "existed parameter is passed"          => ["/?page=1", 200],
      "not-exsisted parameter is passed"     => ["/?page=1000", 404],
      "parameter is not passed"              => ["/", 200]
    )
    def test_page_parameter(data)
      path, status_code = data
      visit path.to_s
      assert_equal status_code, page.status_code
    end
  end

  sub_test_case "invalid page parameter test" do
    setup do
      @site = create(:site)
      @post = create(:post, :whatever, site: @site)
      switch_domain(@site.fqdn)
    end

    data(
      "valid page parameter" => ["/?page=1", 200],
      "parameter is not integer" => ["/?page=foo", 404],
      "parameter is negative value" => ["/?page=-1", 404],
    )
    def test_page_parameter(data)
      path, status_code = data
      visit path.to_s
      assert_equal status_code, page.status_code
    end
  end

  test "404 error should not be occurred in case post does not exist." do
    @site = create(:site)
    switch_domain(@site.fqdn)
    visit "/"
    assert_equal 200, page.status_code
  end

  sub_test_case "pages in one post test" do
    setup do
      @post = create(:post, :whatever, :with_pages)
      switch_domain(@post.site.fqdn)
    end

    sub_test_case "view all true" do
      setup do
        @post.site.update!(view_all: true)
      end
      data(
        "view all parameter is passed"         => ["?all=true", 200, "h1", "title"],
        "existed parameter is passed"          => ["?page=2", 200, "h2", "title 2"],
        "not-exsisted parameter is passed"     => ["?page=1000", 404, "h1", "Hello! my name is 404"],
        "parameter is not passed"              => ["", 200, "h1", "title"]
      )
      def test_page_parameter(data)
        path, status_code, tag_name, tag_value = data
        visit "/#{@post.public_id}#{path}"
        assert_equal status_code, page.status_code
        assert page.has_selector?(tag_name, text: tag_value)
      end
    end

    sub_test_case "view all false" do
      setup do
        @post.site.update!(view_all: false)
      end
      data(
        "existed parameter is passed"          => ["?page=2", 200, "h2", "title 2"],
        "not-exsisted parameter is passed"     => ["?page=1000", 404, "h1", "Hello! my name is 404"],
        "parameter is not passed"              => ["", 200, "h1", "title"]
      )
      def test_page_parameter(data)
        path, status_code, tag_name, tag_value = data
        visit "/#{@post.public_id}#{path}"
        assert_equal status_code, page.status_code
        assert page.has_selector?(tag_name, text: tag_value)
      end
    end
  end

  sub_test_case "serials test" do
    setup do
      @site = create(:site)
      @serials = create_list(:serial, 50, :with_posts, site: @site,)
      switch_domain(@site.fqdn)
    end

    data(
      "existed parameter is passed"          => ["/serials?page=1", 200],
      "not-exsisted parameter is passed"     => ["/serials?page=1000", 404],
      "parameter is not passed"              => ["/serials", 200]
    )
    def test_page_parameter(data)
      path, status_code = data
      visit path.to_s
      assert_equal status_code, page.status_code
    end
  end

  sub_test_case "posts in one serial test" do
    setup do
      @site = create(:site)
      @serial = create(:serial, :with_posts, site: @site)
      switch_domain(@site.fqdn)
    end

    data(
      "existed parameter is passed"          => ["?page=1", 200],
      "not-exsisted parameter is passed"     => ["?page=1000", 404],
      "parameter is not passed"              => ["", 200]
    )
    def test_page_parameter(data)
      path, status_code = data
      visit "/serials/#{@serial.id}#{path}"
      assert_equal status_code, page.status_code
    end
  end

  sub_test_case "participants test" do
    setup do
      @site = create(:site)
      @participants = create_list(:participant, 50, :with_posts, site: @site,)
      switch_domain(@site.fqdn)
    end

    data(
      "existed parameter is passed"          => ["/participants?page=1", 200],
      "not-exsisted parameter is passed"     => ["/participants?page=1000", 404],
      "parameter is not passed"              => ["/participants", 200]
    )
    def test_page_parameter(data)
      path, status_code = data
      visit path.to_s
      assert_equal status_code, page.status_code
    end
  end

  sub_test_case "posts in one participant test" do
    setup do
      @site = create(:site)
      @participant = create(:participant, :with_posts, site: @site)
      switch_domain(@site.fqdn)
    end

    data(
      "existed parameter is passed"          => ["?page=1", 200],
      "not-exsisted parameter is passed"     => ["?page=1000", 404],
      "parameter is not passed"              => ["", 200]
    )
    def test_page_parameter(data)
      path, status_code = data
      visit "/participants/#{@participant.id}#{path}"
      assert_equal status_code, page.status_code
    end
  end

  sub_test_case "posts in one category test" do
    setup do
      @site = create(:site)
      @post = create(:post, :whatever, site: @site)
      switch_domain(@site.fqdn)
    end

    data(
      "existed parameter is passed" => ["?page=1", 200],
      "not-exsisted parameter is passed"     => ["?page=1000", 404],
      "parameter is not passed"              => ["", 200]
    )
    def test_page_parameter(data)
      @post.categories.each do |category|
        path, status_code = data
        visit "/category/#{category.slug}/#{path}"
        assert_equal status_code, page.status_code
      end
    end
  end

  test "404 should not be occurred when access to category page with no posts" do
    @site = create(:site)
    @category = create(:category, site: @site)
    switch_domain(@site.fqdn)
    visit "/category/#{@category.slug}"
    assert_equal 200, page.status_code
  end

  teardown do
    Rails.application.env_config["action_dispatch.show_detailed_exceptions"] = true
    Rails.application.env_config["action_dispatch.show_exceptions"] = false
  end
end
