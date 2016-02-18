require 'test_helper'
require 'active_support/testing/time_helpers'

class CurrentCategoryTest < ActionDispatch::IntegrationTest
  include ActiveSupport::Testing::TimeHelpers

  setup do
    travel_to Time.zone.parse('2000-01-01 00:00:00')

    site = Site.create!(name: 'daimon-news', fqdn: 'www.example.com')
    editor = User.create!(email: 'editor@example.com', password: 'password')
    site.memberships.create!(user: editor)

    visit '/editor'

    fill_in 'Email',    with: 'editor@example.com'
    fill_in 'Password', with: 'password'
    click_on 'Log in'

    within '.navbar-nav' do
      click_on 'カテゴリ'
    end
    click_on 'New Category'

    fill_in 'Name', with: 'Ruby'
    fill_in 'Description',  with: <<~EOS
      Ruby is a programming language.
    EOS
    fill_in 'Slug', with: 'ruby'
    fill_in 'Order', with: '1'

    click_on '登録する'

    within '.navbar-nav' do
      click_on '記事'
    end
    click_on 'New Post'

    select 'Ruby', from: 'Category'
    fill_in 'Title', with: 'Ruby x.x.x Released'
    fill_in 'Body', with: <<~EOS
      Ruby x.x.x released just now!
    EOS
    attach_file "Thumbnail", Rails.root.join('test/fixtures/images/thumbnail.jpg')
    fill_in 'Published at', with: '2000/01/01 00:00'

    click_on '登録する'
  end

  teardown do
    travel_back
  end

  test 'mark current category' do
    visit '/category/ruby'

    within '.menu__items' do
      assert_equal 'Ruby', find('.menu__item[data-menu-item-state=current]').text
    end

    within '.main-pane' do
      click_on 'Ruby x.x.x Released'
    end

    within '.menu__items' do
      assert_equal 'Ruby', find('.menu__item[data-menu-item-state=current]').text
    end
  end
end
