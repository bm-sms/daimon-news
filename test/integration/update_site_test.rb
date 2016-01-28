require 'test_helper'

class UpdateSiteTest < ActionDispatch::IntegrationTest
  setup do
    Site.create!(name: 'daimon-news', fqdn: 'www.example.com', js_url: '', css_url: '')
    User.create!(email: 'admin@example.com', password: 'password')

    visit '/admin'

    fill_in 'Email', with: 'admin@example.com'
    fill_in 'Password', with: 'password'
    click_on 'Log in'

    within '.navbar-nav' do
      click_on 'サイト情報'
    end
  end

  test 'Update site' do
    fill_in 'Name', with: 'Awesome daimon-news'

    click_on '更新する'

    assert_equal '"Awesome daimon-news" の管理画面です。', find('h1').text
  end
end
