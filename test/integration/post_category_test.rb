require "test_helper"

class PostCategoryTest < ActionDispatch::IntegrationTest
  setup do
    @site = create(:site, fqdn: "127.0.0.1")
    editor = create(:user, sites: [@site])

    login_as_editor(site: @site, editor: editor)

    @post = create(:post, :whatever, site: @site)
  end

  attribute :js, true
  test "can reset category" do
    click_on("記事")
    within(:row, @post.title) do
      click_on("Edit")
    end

    within(:form_group, "Categories") do
      click_on("Remove category")
    end

    click_on("更新する")

    within(:form_group, "Categories") do
      assert_not page.has_css?(".nested-fields")
      assert_equal "を入力してください", page.find(".has-error").text

      click_on("Add category")

      select @post.main_category.full_name
    end

    click_on("更新する")

    assert page.has_css?(".alert", text: "記事が更新されました。")

    within("#categories") do
      assert page.has_content?(@post.main_category.full_name)
    end
  end
end
