require 'test_helper'

class AssignEditorToSiteTest < ActionDispatch::IntegrationTest
  setup do
    @site = create(:site)
    admin = create(:user, :admin)
    @user_to_be_editor = create(:user)
    @user_not_to_be_editor = create(:user)

    login_as_admin(site: @site, admin: admin)
  end

  test 'Assign' do
    visit "/admin/sites/#{@site.id}"

    click_on 'Edit editor'

    check @user_to_be_editor.email

    click_on '更新する'

    assert page.has_css?('.alert', text: 'サイトの編集者が更新されました')

    within '.editors' do
      assert page.has_content?(@user_to_be_editor.email)
      assert_not page.has_content?(@user_not_to_be_editor.email)
    end
  end
end
