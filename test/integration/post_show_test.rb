require 'test_helper'

class PostShowTest < ActionDispatch::IntegrationTest
  setup do
    @post = create(:post, :whatever, :with_credit, body: <<~EOS.encode(crlf_newline: true))
      <h1> hi </h1>
      contents
    EOS

    switch_domain(@post.site.fqdn)
  end

  test "?all=true should not raise error" do
    visit "/#{@post.public_id}?all=true"

    within '.post__body' do
      assert page.has_selector?('h1', text: 'hi')
      assert page.has_selector?('section.credits')
    end
  end

  test "page should display credits" do
    visit "/#{@post.public_id}"

    within '.post__body' do
      assert page.has_selector?('h1', text: 'hi')
      assert page.has_selector?('section.credits')
    end
  end
end
