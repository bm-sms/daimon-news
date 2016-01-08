require 'test_helper'

module PostHelper
  def create_published_post(body:, original_id:)
    site = Site.create!(name: 'test', fqdn: 'www.example.com', js_url: '', css_url: '')
    category = site.categories.create!(name: 'category1', slug: 'cate1', order: 1)
    site.posts.create!(
      body:         body,
      original_id:  original_id,
      published_at: Time.current,
      category:     category
    )
  end
end

class PostBodyHeaderTest < ActionDispatch::IntegrationTest
  include PostHelper

  setup do
    create_published_post(
      body: <<~EOS.encode(crlf_newline: true),
        <h1> hi </h1>
        contents
      EOS
      original_id: 1
    )
  end

  test "body shouldn't have <br>" do
    get '/1'

    assert_select '.post__body' do
      assert_select 'h1', 'hi'
      assert_select 'br', false
    end
  end
end

class PostBodyNewLineTest < ActionDispatch::IntegrationTest
  include PostHelper

  setup do
    create_published_post(
      body: <<~EOS.encode(crlf_newline: true),
        following line should be breaked:
        hi
      EOS
      original_id: 1
    )
  end

  test 'body should have <br>' do
    get '/1'

    assert_select '.post__body' do
      assert_select 'p' do |elem|
        assert_equal 3, elem.children.count

        assert_equal 'following line should be breaked:', elem.children[0].text
        assert_equal 'br', elem.children[1].name
        assert_equal "\n hi", elem.children[2].text
      end
    end
  end
end
