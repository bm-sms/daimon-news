require "test_helper"

class PostPublicIdTest < ActionDispatch::IntegrationTest
  setup do
    site = create(:site, fqdn: "127.0.0.1")
    user = create(:user, sites: [site])
    login_as_editor(site: site, editor: user)

    @post = create(:post, site: site, category: create(:category, site: site))
    @post.update!(public_id: @post.id + 1)
  end

  test "Can update a post which has id != public_id" do
    # TODO: We should navigate by click
    visit "/editor/posts/#{@post.public_id}/edit"

    fill_in "Title", with: "Ruby x.x.x Released"

    click_on "更新する"

    visit "/#{@post.public_id}"

    within ".post__title" do
      assert_equal "Ruby x.x.x Released", page.text
    end
  end
end
