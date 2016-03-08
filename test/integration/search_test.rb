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

  test 'no published posts should be hide' do
    create_post(site: @current_site,
                title: 'post1 is published',
                body: 'body...')
    create_post(site: @current_site,
                title: 'post2 is not published',
                body: 'body...',
                published_at: Time.now.since(1.hour))
    create_post(site: @current_site,
                title: 'post3 is published',
                body: 'body...')

    visit '/'

    fill_in 'query[keywords]', with: 'body'

    click_on 'search'

    within('main') do
      assert_equal '「body」を含む記事は2件見つかりました。', find('p').text
      within('ol') do
        assert find_link('post1 is published')
        assert find_link('post3 is published')
      end
    end
  end

  private

  def create_post(attributes)
    post = create(:post, attributes)
    @indexer.add(post)
  end
end
