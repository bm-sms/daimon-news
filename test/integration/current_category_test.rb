require "test_helper"
require "active_support/testing/time_helpers"

class CurrentCategoryTest < ActionDispatch::IntegrationTest
  include ActiveSupport::Testing::TimeHelpers

  setup do
    travel_to Time.zone.parse("2000-01-01 00:00:00")

    @site = create(:site, name: "daimon-news", fqdn: "example.com")

    description = <<~EOS
      [Ruby](https://www.ruby-lang.org/) is a programming language.
    EOS
    category = create(:category, site: @site, name: "Ruby", slug: "ruby", description: description)
    body = <<~EOS
      Ruby x.x.x released just now!
    EOS
    create(:post,
           site: @site,
           title: "Ruby x.x.x Released",
           body: body,
           categories: [category],
           thumbnail: Rails.root.join("test/fixtures/images/thumbnail.jpg").open,
           published_at: Time.zone.parse("2000/01/01 00:00"))
    switch_domain(@site.fqdn)
  end

  teardown do
    travel_back
  end

  test "mark current category" do
    visit("/category/ruby")

    assert_equal("Ruby | #{@site.name}", title)

    within(".menu__items") do
      assert_equal("Ruby", find(".menu__item[data-menu-item-state=current]").text)
    end

    within(".main-pane") do
      click_on "Ruby x.x.x Released"
    end

    within(".menu__items") do
      assert_equal("Ruby", find(".menu__item[data-menu-item-state=current]").text)
    end
  end

  test "render description as Markdown" do
    visit("/category/ruby")

    assert_equal("https://www.ruby-lang.org/", find(".category-description a")[:href])
  end
end
