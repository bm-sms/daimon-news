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
    create_post(site: @current_site,
                title: 'the post of the current site',
                body: 'contents...')
    create_post(site: @other_site,
                title: 'the post of the other site',
                body: 'contents...')

    visit '/'

    fill_in 'query[keywords]', with: 'contents'

    click_on 'search'

    within('main') do
      assert_equal '「contents」を含む記事は1件見つかりました。', find('p').text
      within('ol') do
        assert_equal 'the post of the current site', find('a').text
      end
    end
  end

  private

  def create_post(attributes)
    post = create(:post, attributes)
    @indexer.add(post)
  end
end
