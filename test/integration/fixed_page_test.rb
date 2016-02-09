require 'test_helper'

class FixedPageTest < ActionDispatch::IntegrationTest
  setup do
    site = Site.create!(name: 'daimon-news', fqdn: 'www.example.com')
    editor = User.create!(email: 'editor@example.com', password: 'password')
    site.memberships.create!(user: editor)

    visit '/editor'

    fill_in 'Email',    with: 'editor@example.com'
    fill_in 'Password', with: 'password'
    click_on 'Log in'

    within '.navbar-nav' do
      click_on '固定ページ'
    end
    click_on 'New Fixed page'

    fill_in 'Title', with: 'About daimon-news'
    fill_in 'Body',  with: <<~EOS
      ## What is daimon-news

      daimon-news is the application to open news sites fast and easy.
    EOS
    fill_in 'Slug', with: 'about'

    click_on '登録する'
  end

  test 'body is converted to html' do
    visit '/about'

    within '.post__body' do
      assert page.has_selector?('h2', text: 'What is daimon-news')
    end
  end
end
