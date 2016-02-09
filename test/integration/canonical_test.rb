require 'test_helper'

class CanonicalTest < ActionDispatch::IntegrationTest
  setup do
    site = Site.create!(name: 'daimon-news', fqdn: 'www.example.com')
    category = site.categories.create!(name: 'category1', slug: 'cate1', order: 1)
    @post = site.posts.create!(
      title:        'Hi',
      body:         <<~EOS,
        # Hi
        this is daimon
      EOS
      published_at: Time.current,
      category:     category
    )
  end

  test 'Canonical must be absolute path' do
    visit '/'

    within '.main-pane' do
      click_on 'Hi'
    end

    assert_equal "http://www.example.com/#{@post.id}?all=true", find('link[rel=canonical]', visible: false)[:href]
  end
end
