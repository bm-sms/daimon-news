require "test_helper"

class HierarchicalCategoryTest < ActionDispatch::IntegrationTest
  setup do
    @site = create(:site, name: "daimon-news", fqdn: "example.com")

    @category = create(:category, name: "programming", slug: "programming", site: @site)
    @sub_category = create(:category, name: "Ruby", slug: "ruby", parent: @category, site: @site)
    create(:post,
           site: @site,
           title: "title",
           body: "body",
           thumbnail: Rails.root.join("test/fixtures/images/thumbnail.jpg").open,
           categorizations_attributes: [{category: @sub_category, order: 1}])
    switch_domain(@site.fqdn)
  end

  test "sub category" do
    visit("/category/programming")

    within(".category-summary-list") do
      link = find_link("Ruby")
      assert_equal("http://example.com/category/ruby", link["href"])
    end
  end
end
