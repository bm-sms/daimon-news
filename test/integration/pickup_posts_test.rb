require "test_helper"

class PickupPostTest < ActionDispatch::IntegrationTest
  setup do
    @site = create(:site, fqdn: "127.0.0.1")
    switch_domain(@site.fqdn)

    create(:pickup_post, :whatever, order: 1, site: @site, post: create(:post, :whatever, title: 'Ruby', site: @site))
    create(:pickup_post, :whatever, order: 2, site: @site, post: create(:post, :whatever, :unpublished, title: 'Java', site: @site))
  end

  test "show only publised post" do
    visit "/"

    within ".pickup-articles" do
      assert page.has_content?("Ruby")
      assert page.has_no_content?("Java")
    end
  end
end
