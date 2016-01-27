require 'test_helper'
require 'active_support/testing/time_helpers'

class CurrentCategoryTest < ActionDispatch::IntegrationTest
  include ActiveSupport::Testing::TimeHelpers

  setup do
    travel_to Time.zone.parse('2000-01-01 00:00:00')

    Site.create!(name: 'daimon-news', fqdn: 'www.example.com', js_url: '', css_url: '')
    User.create!(email: 'admin@example.com', password: 'password')

    visit '/admin'

    fill_in 'Email', with: 'admin@example.com'
    fill_in 'Password', with: 'password'
    click_on 'Log in'

    click_on 'Categories'
    click_on 'Category を作成する'

    select 'daimon-news', from: 'Site'
    fill_in 'Name', with: 'Ruby'
    fill_in 'Description',  with: <<~EOS
      Ruby is a programming language.
    EOS
    fill_in 'Slug', with: 'ruby'
    fill_in 'Order', with: '1'

    click_on 'Categoryを作成'

    click_on 'Posts'
    click_on 'Post を作成する'

    select 'daimon-news', from: 'Site'
    select 'Ruby', from: 'Category'
    fill_in 'Title', with: 'Ruby x.x.x Released'
    fill_in 'Body', with: <<~EOS
      Ruby x.x.x released just now!
    EOS
    select '2000', from: '年'
    select '1月', from: '月'
    select '1', from: '日'
    select '00', from: '時'
    select '00', from: '分'

    click_on 'Postを作成'
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
