require "test_helper"

class PageNotFoundTest < ActionDispatch::IntegrationTest
  setup do
    Rails.application.env_config["action_dispatch.show_detailed_exceptions"] = false
    Rails.application.env_config["action_dispatch.show_exceptions"] = true
    @post = create(:post, :whatever, :with_pages)
    switch_domain(@post.site.fqdn)
  end

  test "200 success status code should be returned when existed page is accessed" do
    page_num = @post.pages.size - 1
    visit "/#{@post.public_id}?page=#{page_num}"
    assert_equal 200, page.status_code
    assert page.has_selector?("h2", text: "title 2")
  end

  test "404 error code should be returned when not-existed page is accessed" do
    page_num = @post.pages.size + 1
    visit "/#{@post.public_id}?page=#{page_num}"
    assert_equal 404, page.status_code
    assert page.has_selector?("h1", "Hello! my name is 404")
  end

  teardown do
    Rails.application.env_config["action_dispatch.show_detailed_exceptions"] = true
    Rails.application.env_config["action_dispatch.show_exceptions"] = false
  end
end
