require 'test_helper'

class WipSiteTest < ActionDispatch::IntegrationTest
  setup do
    @site   = create(:site, opened: false)
    @post   = create(:post, :whatever, site: @site)
    @editor = create(:user)

    switch_domain(@site.fqdn)
  end

  sub_test_case "When user isn't an editor of the site" do
    test "User can't show the site" do
      login_as_editor(site: @site, editor: @editor)

      visit '/'

      assert_equal 403, status_code
    end
  end

  sub_test_case "When user is an editor of the site" do
    setup do
      @editor.sites << @site
    end

    test 'User can show the site' do
      login_as_editor(site: @site, editor: @editor)

      visit '/'

      within 'main' do
        assert_equal @post.title, find('.article-summary:not(.ad) .article-summary__title').text
      end
    end
  end

  sub_test_case 'When user is an admin' do
    setup do
      @admin = create(:user, :admin)
    end

    test 'User can show the site' do
      login_as_admin(site: @site, admin: @admin)

      visit '/'

      within 'main' do
        assert_equal @post.title, find('.article-summary:not(.ad) .article-summary__title').text
      end
    end
  end
end

