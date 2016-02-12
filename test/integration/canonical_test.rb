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
  end

  test 'Canonical must be absolute path' do
    visit '/'

    within '.main-pane' do
      click_on 'Hi'
    end

    assert_equal "http://#{@post.site.fqdn}/#{@post.id}?all=true", find('link[rel=canonical]', visible: false)[:href]
  end
end
