require 'test_helper'

class PostBodyHeaderTest < ActionDispatch::IntegrationTest
  setup do
    @post = create(:post, :whatever, body: <<~EOS.encode(crlf_newline: true))
      <h1> hi </h1>
      contents
    EOS

    switch_domain(@post.site.fqdn)
  end

  test "body shouldn't have <br>" do
    visit "/#{@post.public_id}"

    within '.post__body' do
      assert page.has_selector?('h1', text: 'hi')
      assert_not page.has_selector?('br')
    end
  end
end

class PostBodyNewLineTest < ActionDispatch::IntegrationTest
  setup do
    @post = create(:post, :whatever, body: <<~EOS.encode(crlf_newline: true))
      following line should be breaked:
      hi
    EOS

    switch_domain(@post.site.fqdn)
  end

  test 'body should have <br>' do
    visit "/#{@post.public_id}"

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
  setup do
    @site = create(:site)
    @post = create(:post, :whatever, site: @site)

    switch_domain(@post.site.fqdn)
  end

  sub_test_case 'w/o photo' do
    setup do
      participant = create(:participant, site: @site)
      @post.credits << build(:credit, :whatever, site: @site, participant: participant)
    end

    test 'body should have .credits' do
      visit "/#{@post.public_id}"

      within '.post .credits' do
        assert page.has_css?('strong', text: @post.credits.first.role.name)
      end
    end
  end

  sub_test_case 'w/ photo' do
    setup do
      participant = create(:participant, :with_photo, site: @site)
      @post.credits << build(:credit, :whatever, site: @site, participant: participant)
    end

    test 'body should have .participant__photo' do
      visit "/#{@post.public_id}"

      within '.post .credits' do
        assert page.has_content?('Awesome description')

        within '.participant__photo' do
          image = find('img').native
          assert_equal("face.png", File.basename(image["src"]))
        end
      end
    end
  end
end
