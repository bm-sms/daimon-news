require 'test_helper'

class AdminTest < ActionDispatch::IntegrationTest
  setup do
    Site.create!(name: 'admin', fqdn: 'www.example.com')
    User.create!(email: 'admin@example.com', password: 'password', admin: true)

    visit '/admin'

    fill_in 'Email',    with: 'admin@example.com'
    fill_in 'Password', with: 'password'
    click_on 'Log in'

    visit '/admin'
  end

  test 'Site' do
    click_on 'サイト情報'
    click_on 'New site'

    fill_in 'Name', with: 'daimon'
    fill_in 'Fqdn', with: 'daimon.lvh.me'

    click_on '登録する'

    assert_equal 'http://daimon.lvh.me/', current_url

    visit '/admin'

    click_on 'サイト情報'

    within :xpath, '//tr[./td[contains(text(), "daimon")]]' do
      click_on 'Edit'
    end

    fill_in 'Description', with: 'News site'
    click_on '更新する'

    assert page.has_css?('p', text: 'Description: News site')
  end

  test 'User' do
    click_on 'ユーザ'
    click_on 'New user'

    fill_in 'Email',            with: 'alice@example.com'
    fill_in 'Password',         with: 'password'
    fill_in 'Confirm Password', with: 'password'

    click_on '登録する'

    assert page.has_css?('td', text: 'alice@example.com')

    try_login_as_admin email: 'alice@example.com', password: 'password' do
      visit '/admin'

      assert_equal '/', current_path
    end

    click_on 'ユーザ'

    within :xpath, '//tr[./td[contains(text(), "alice@example.com")]]' do
      click_on 'Edit'
    end

    check 'Admin'

    click_on '更新する'

    try_login_as_admin email: 'alice@example.com', password: 'password' do
      visit '/admin'

      assert_equal '/admin', current_path
    end

    within :xpath, '//tr[./td[contains(text(), "alice@example.com")]]' do
      click_on 'Destroy'
    end

    try_login_as_admin email: 'alice@example.com', password: 'password' do
      assert_equal '/users/sign_in', current_path
    end
  end

  def try_login_as_admin(email:, password:)
    using_session SecureRandom.uuid do
      visit '/admin'

      fill_in 'Email',    with: email
      fill_in 'Password', with: password
      click_on 'Log in'

      yield
    end
  end
end
