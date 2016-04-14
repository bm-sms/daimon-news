require "test_helper"
require "active_support/testing/time_helpers"

class CategoryTitleTest < ActionDispatch::IntegrationTest
  include ActiveSupport::Testing::TimeHelpers

  setup do
    @site = Site.create!(name: "daimon-news", fqdn: "www.example.com")
    editor = User.create!(email: "editor@example.com", password: "password")
    @site.memberships.create!(user: editor)

    visit "/editor"

    fill_in "Email",    with: "editor@example.com"
    fill_in "Password", with: "password"
    click_on "Log in"
  end

  test "Category#name should be set to title if Category#title isn't set" do
    visit "/editor"
    within ".navbar-nav" do
      click_on "カテゴリ"
    end
    click_on "New Category"

    fill_in "Name", with: "Ruby"
    fill_in "Slug", with: "ruby"
    fill_in "Order", with: "1"

    click_on "登録する"

    visit "/category/ruby"

    assert_equal "Ruby | #{@site.name}", title
  end

  test "Category#title should be set to title if it's set" do
    visit "/editor"
    within ".navbar-nav" do
      click_on "カテゴリ"
    end
    click_on "New Category"

    fill_in "Name", with: "Ruby"
    fill_in "Slug", with: "ruby"
    fill_in "Order", with: "1"
    fill_in "Title", with: "Title"

    click_on "登録する"

    visit "/category/ruby"

    assert_equal "Title | #{@site.name}", title
  end
end
