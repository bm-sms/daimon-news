require 'test_helper'

class EditorTest < ActionDispatch::IntegrationTest
  setup do
    site = create(:site)
    editor = create(:user, sites: [site])
    login_as_editor(site: site, editor: editor)
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

    within :row, 'Ruby' do
      click_on 'Edit'
    end

    fill_in 'Name', with: 'Ruby lang'

    click_on '更新する'

    assert page.has_css?('p', text: 'Name: Ruby lang')

    click_on 'Back'

    within :row, 'Ruby lang' do
      click_on 'Destroy'
    end

    assert_equal('/editor/categories', page.current_path)
    assert_not page.has_css?('td', text: 'Ruby lang')
  end

  test 'Author' do
    click_on '著者情報'
    click_on 'New Author'

    fill_in 'Name', with: 'Ruby'
    fill_in 'Description', with: "Ruby is a programing language."

    click_on '登録する'

    assert page.has_css?('p', text: 'Name: Ruby')

    click_on 'Back'

    within :row, 'Ruby' do
      click_on 'Edit'
    end

    fill_in 'Name', with: 'Ruby lang'

    click_on '更新する'

    assert page.has_css?('p', text: 'Name: Ruby lang')

    click_on 'Back'

    within :row, 'Ruby lang' do
      click_on 'Destroy'
    end

    assert_equal('/editor/authors', page.current_path)
    assert_not page.has_css?('td', text: 'Ruby lang')
  end

  test 'Fixed Page' do
    click_on '固定ページ'

    click_on 'New Fixed page'

    fill_in 'Title', with: 'Ruby'
    fill_in 'Body',  with: 'Ruby is a programming language.'
    fill_in 'Slug',  with: 'ruby'

    click_on '登録する'

    assert page.has_css?('p', text: 'Title: Ruby')

    click_on 'Back'

    within :row, 'Ruby' do
      click_on 'Edit'
    end

    fill_in 'Title', with: 'Ruby lang'

    click_on '更新する'

    assert page.has_css?('p', text: 'Title: Ruby lang')

    click_on 'Back'

    within :row, 'Ruby lang' do
      click_on 'Destroy'
    end

    assert_equal('/editor/fixed_pages', page.current_path)
    assert_not page.has_css?('td', text: 'Ruby lang')
  end

  test 'Link' do
    click_on 'リンク'

    click_on 'New Link'

    fill_in 'Text',  with: 'Ruby'
    fill_in 'Url',   with: 'http://example.com'
    fill_in 'Order', with: '1'

    click_on '登録する'

    assert page.has_css?('p', text: 'Text: Ruby')

    click_on 'Back'

    within :row, 'Ruby' do
      click_on 'Edit'
    end

    fill_in 'Text', with: 'Ruby lang'

    click_on '更新する'

    assert page.has_css?('p', text: 'Text: Ruby lang')

    click_on 'Back'

    within :row, 'Ruby lang' do
      click_on 'Destroy'
    end

    assert_equal('/editor/links', page.current_path)
    assert_not page.has_css?('td', text: 'Ruby lang')
  end
end
