require 'test_helper'

class CanonicalTest < ActionDispatch::IntegrationTest
  setup do
    @post = create(:post,
      title:        'Hi',
      body:         <<~EOS,
        # Hi
        this is daimon
      EOS
    )

    switch_domain(@post.site.fqdn)
  end

  test 'Canonical must be absolute path' do
    visit '/'

    within '.main-pane' do
      click_on 'Hi'
    end

    assert_equal "http://#{@post.site.fqdn}/#{@post.public_id}?all=true", find('link[rel=canonical]', visible: false)[:href]
  end

  sub_test_case 'category page' do
    setup do
      @category = create(:category, site: @post.site)
    end

    data({
      "no parameter"            => "",
      "pagination"              => "?page=2",
      "unexpected"              => "?aaa=bbb&c_c=d.d",
      "all=true"                => "?all=true",
      "all=true and unexpected" => "?all=true&aaa=123",
    })
    def test_normalize(data)
      visit "/category/#{@category.slug}#{data}"
      assert_equal "http://#{@post.site.fqdn}/category/#{@category.slug}?all=true",
                   find('link[rel=canonical]', visible: false)[:href]
    end
  end
end
