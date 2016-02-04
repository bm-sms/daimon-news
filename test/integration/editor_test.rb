require 'test_helper'

class EditorTest < ActionDispatch::IntegrationTest
  setup do
    site = Site.create!(name: 'daimon', fqdn: 'www.example.com')
    editor = User.create!(email: 'editor@example.com', password: 'password')
    site.memberships.create!(user: editor)

    visit '/editor'

    fill_in 'Email',    with:'editor@example.com'
    fill_in 'Password', with:'password'
    click_on 'Log in'

    visit '/editor'
  end

  test 'Category' do
    click_on 'カテゴリ'
    click_on 'New Category'

    fill_in 'Name',        with: 'Ruby'
    fill_in 'Description', with: 'Ruby is a programming language.'
    fill_in 'Slug',        with: 'ruby'
    fill_in 'Order',       with: '1'

    click_on '登録する'

    assert page.has_css?('p', text: 'Name: Ruby')

    click_on 'Back'

    within :xpath, '//tr[./td[contains(text(), "Ruby")]]' do
      click_on 'Edit'
    end

    fill_in 'Name', with: 'Ruby lang'

    click_on '更新する'

    assert page.has_css?('p', text: 'Name: Ruby lang')

    click_on 'Back'

    within :xpath, '//tr[./td[contains(text(), "Ruby lang")]]' do
      click_on 'Destroy'
    end

    assert_not page.has_css?('td', text: 'Ruby lang')
  end
end
