require 'test_helper'

class SearchTest < ActionDispatch::IntegrationTest
  setup do
    setup_groonga_database
    @current_site = create(:site)
    @other_site = create(:site)
    switch_domain(@current_site.fqdn)
    @indexer = PostIndexer.new
  end

  teardown do
    teardown_groonga_database
  end

  test 'only posts of the current site' do
    create_post(@current_site, 'current site', 'contents...')
    create_post(@other_site, 'other site', 'contents...')

    visit '/'

    fill_in 'query[keywords]', with: 'contents'

    click_on 'search'

    within('main') do
      assert_equal '「contents」を含む記事は1件見つかりました。', find('p').text
      within('ol') do
        assert_equal 'current site', find('a').text
      end
    end
  end

  private

  def create_post(site, title, body)
    post = create(:post, site: site, title: title, body: body)
    @indexer.add(post)
  end
end
