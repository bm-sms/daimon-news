require 'test_helper'

class CustomizableTagTest < ActionDispatch::IntegrationTest
  setup do
    @site = create(:site)
    login_as_admin(site: @site, admin: create(:user, :admin))
  end

  test 'Customizable head and promotion area' do
    click_on 'サイト情報'

    within :row, @site.name do
      click_on 'Edit'
    end

    fill_in 'Head tag', with: <<~EOS
      <meta name="test">
    EOS

    fill_in 'Promotion tag', with: <<~EOS
      <h1 id="test">Hi</h1>
    EOS

    click_on '更新する'

    visit '/'

    # TODO xxx/yyy の運用をやめたらテストからも xxx を取り除く

    assert page.has_css?('meta[name="test"]', visible: false)
    assert_equal 'Hi', find('.xxx h1#test').text
  end
end
