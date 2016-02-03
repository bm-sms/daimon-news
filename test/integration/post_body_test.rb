require 'test_helper'

module PostHelper
  def create_published_post(body:, id:)
    site = Site.create!(name: 'test', fqdn: 'www.example.com', js_url: '', css_url: '')
    category = site.categories.create!(name: 'category1', slug: 'cate1', order: 1)
    site.posts.create!(
      id:           id,
      body:         body,
      published_at: Time.current,
      category:     category
    )
  end
end

class PostBodyHeaderTest < ActionDispatch::IntegrationTest
  include PostHelper

  setup do
    create_published_post(
      id: 1,
      body: <<~EOS.encode(crlf_newline: true)
        <h1> hi </h1>
        contents
      EOS
    )
  end

  test "body shouldn't have <br>" do
    visit '/1'

    within '.post__body' do
      assert page.has_selector?('h1', text: 'hi')
      assert_not page.has_selector?('br')
    end
  end
end

class PostBodyNewLineTest < ActionDispatch::IntegrationTest
  include PostHelper

  setup do
    create_published_post(
      id: 1,
      body: <<~EOS.encode(crlf_newline: true)
        following line should be breaked:
        hi
      EOS
    )
  end

  test 'body should have <br>' do
    visit '/1'

    within '.post__body' do
      elem = find('p').native

      assert_equal 3, elem.children.count

      assert_equal 'following line should be breaked:', elem.children[0].text
      assert_equal 'br', elem.children[1].name
      assert_equal "\nhi", elem.children[2].text
    end
  end
end
