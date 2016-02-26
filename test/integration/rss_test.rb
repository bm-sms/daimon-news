require 'test_helper'

class RssTest < ActionDispatch::IntegrationTest
  setup do
    @post = create(:post, :whatever, body: <<~EOS)
      # Lorem ipsum dolor sit amet,

      consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
      Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.

      - Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.
      - Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
    EOS

    switch_domain(@post.site.fqdn)
  end

  test '' do
    visit '/feed.xml'

    within 'item' do
      assert_equal @post.title, find('title').text
      assert_equal %|<img src="#{@post.thumbnail_url}" alt="Thumbnail" />|, find('description').text.scan(%r|<img.*/>|).first
      description = find('description').text.scan(%r|<p>(.*)</p>|).first.first
      assert_equal "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad mi...",
        description
      assert_equal 140, description.length
    end
  end
end
