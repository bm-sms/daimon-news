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

        <!--nextpage-->

        # 2 page

        <!--nextpage-->

        # 3 page
      EOS
    )

    switch_domain(@post.site.fqdn)
  end

  test 'Canonical must be absolute path' do
    visit '/'

    within '.main-pane' do
      click_on 'Hi'
    end

    assert_equal "http://#{@post.site.fqdn}/#{@post.public_id}", find('link[rel=canonical]', visible: false)[:href]
  end

  sub_test_case 'category page' do
    setup do
      @category = create(:category, site: @post.site)
    end

    data({
      'no parameter'          => ['',                ''],
      'unexpected'            => ['?aaa=123',        ''],
      'page=1'                => ['?page=1',         ''],
      'page=1 and unexpected' => ['?page=1&aaa=123', ''],
      'page=2'                => ['?page=2',         '?page=2'],
      'page=2 and unexpected' => ['?page=2&aaa=123', '?page=2'],
    })
    def test_normalize_parameter(data)
      raw, expected = data

      visit "/category/#{@category.slug}#{raw}"
      assert_canonical_url "http://#{@post.site.fqdn}/category/#{@category.slug}#{expected}"
    end
  end

  sub_test_case 'post page' do
    data({
      'no parameter'          => ['',                ''],
      'unexpected'            => ['?aaa=123',        ''],
      'page=1'                => ['?page=1',         ''],
      'page=1 and unexpected' => ['?page=1&aaa=123', ''],
      'page=2'                => ['?page=2',         '?page=2'],
      'page=2 and unexpected' => ['?page=2&aaa=123', '?page=2'],
    })
    def test_normalize(data)
      raw, expected = data

      visit "/#{@post.public_id}#{raw}"
      assert_canonical_url "http://#{@post.site.fqdn}/#{@post.public_id}#{expected}"
    end
  end

  sub_test_case 'welcome page' do
    data({
      'no parameter'          => ['',                ''],
      'unexpected'            => ['?aaa=123',        ''],
      'page=1'                => ['?page=1',         ''],
      'page=1 and unexpected' => ['?page=1&aaa=123', ''],
      'page=2'                => ['?page=2',         '?page=2'],
      'page=2 and unexpected' => ['?page=2&aaa=123', '?page=2'],
    })
    def test_normalize(data)
      raw, expected = data

      visit "/#{raw}"
      assert_canonical_url "http://#{@post.site.fqdn}/#{expected}"
    end
  end

  def assert_canonical_url(url)
    assert_equal url, find('link[rel=canonical]', visible: false)[:href]
  end
end
