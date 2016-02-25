require 'test_helper'

class CanonicalTest < ActionDispatch::IntegrationTest
  setup do
    @post = create(
      :post,
      :whatever,
      title: 'Hi',
      body: <<~EOS,
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
      'no parameter'          => ['',                '?page=1'],
      'unexpected'            => ['?aaa=123',        '?page=1'],
      'page=1'                => ['?page=1',         '?page=1'],
      'page=1 and unexpected' => ['?page=1&aaa=123', '?page=1'],
      'page=2'                => ['?page=2',         '?page=2'],
      'page=2 and unexpected' => ['?page=2&aaa=123', '?page=2'],
    })
    def test_normalize_parameter(data)
      raw_parameter = data[0]
      normalized_parameter = data[1]
      visit "/category/#{@category.slug}#{raw_parameter}"
      assert_equal "http://#{@post.site.fqdn}/category/#{@category.slug}#{normalized_parameter}",
                   find('link[rel=canonical]', visible: false)[:href]
    end
  end

  sub_test_case 'post page' do
    data({
      "no parameter"            => "",
      "pagination"              => "?page=2",
      "unexpected"              => "?aaa=bbb&c_c=d.d",
      "all=true"                => "?all=true",
      "all=true and unexpected" => "?all=true&aaa=123",
    })
    def test_normalize(data)
      visit "/#{@post.public_id}#{data}"
      assert_equal "http://#{@post.site.fqdn}/#{@post.public_id}?all=true",
                   find('link[rel=canonical]', visible: false)[:href]
    end
  end
end
