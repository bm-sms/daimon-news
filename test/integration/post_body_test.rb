require 'test_helper'

class PostBodyHeaderTest < ActionDispatch::IntegrationTest
  setup do
    @post = create(:post, body: <<~EOS.encode(crlf_newline: true))
      <h1> hi </h1>
      contents
    EOS

    switch_domain(@post.site.fqdn)
  end

  test "body shouldn't have <br>" do
    visit "/#{@post.id}"

    within '.post__body' do
      assert page.has_selector?('h1', text: 'hi')
      assert_not page.has_selector?('br')
    end
  end
end

class PostBodyNewLineTest < ActionDispatch::IntegrationTest
  setup do
    @post = create(:post, body: <<~EOS.encode(crlf_newline: true))
      following line should be breaked:
      hi
    EOS

    switch_domain(@post.site.fqdn)
  end

  test 'body should have <br>' do
    visit "/#{@post.id}"

    within '.post__body' do
      elem = find('p').native

      assert_equal 3, elem.children.count

      assert_equal 'following line should be breaked:', elem.children[0].text
      assert_equal 'br', elem.children[1].name
      assert_equal "\nhi", elem.children[2].text
    end
  end
end

class PostBodyWithAuthorTest < ActionDispatch::IntegrationTest

  sub_test_case 'w/o photo' do
    setup do
      @post = create(:post_with_author)
      switch_domain(@post.site.fqdn)
    end

    test 'body should have .author' do
      visit "/#{@post.id}"

      within '.post__body' do
        within '.author' do
          elem = find('p').native
          assert_equal(1, elem.children.count)
          assert_equal('Author 1 description', elem.children.text)
        end
      end
    end
  end
end
