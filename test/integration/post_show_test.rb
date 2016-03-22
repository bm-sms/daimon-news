require 'test_helper'

class PostShowTest < ActionDispatch::IntegrationTest
  setup do
    @post = create(:post, :whatever, :with_credit, body: <<~EOS.encode(crlf_newline: true))
      # hi

      contents

      <!--nextpage-->

      ## hi hi

      contents
      contents
      contents

    EOS

    switch_domain(@post.site.fqdn)
  end

  test "should display credits when ?all=true" do
    visit "/#{@post.public_id}?all=true"

    within '.post' do
      assert page.has_selector?('h1', text: 'hi')
      assert page.has_selector?('section.credits')
    end
  end

  test "page should display credits" do
    visit "/#{@post.public_id}"

    within '.post' do
      assert page.has_selector?('h1', text: 'hi')
      assert page.has_selector?('section.credits')
    end
  end

  test "page 2 should not display credits" do
    visit "/#{@post.public_id}?page=2"

    within '.post' do
      assert page.has_selector?('h2', text: 'hi hi')
      assert page.has_no_selector?('section.credits')
    end
  end
end
