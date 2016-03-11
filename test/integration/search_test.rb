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

  test 'posts of other sites should not be shown' do
    create_post(site: @current_site,
                title: 'the post of the current site',
                body: 'contents...')
    create_post(site: @other_site,
                title: 'the post of the other site',
                body: 'contents...')

    visit '/'

    fill_in 'query[keywords]', with: 'contents'

    click_on '検索'

    within('main') do
      assert_equal '「contents」を含む記事は1件見つかりました。', find('.message').text
      within('ul') do
        assert find_link('the post of the current site')
      end
    end

    within('aside') do
      assert_equal 'contents', find('#query_keywords').value
    end
  end

  test 'unpublished posts should not be shown' do
    create_post(site: @current_site,
                title: 'post1 is published',
                body: 'body...')
    create_post(site: @current_site,
                title: 'post2 is not published',
                body: 'body...',
                published_at: 1.hour.from_now)
    create_post(site: @current_site,
                title: 'post3 is published',
                body: 'body...')
    stopped_publishing_post = create_post(site: @current_site,
                                          title: 'post4 is stopped publishing',
                                          body: 'body...')
    stopped_publishing_post.published_at = nil
    stopped_publishing_post.save!

    visit '/'

    fill_in 'query[keywords]', with: 'body'

    click_on '検索'

    within('main') do
      assert_equal '「body」を含む記事は2件見つかりました。', find('.message').text
      within('ul') do
        assert find_link('post1 is published')
        assert find_link('post3 is published')
      end
    end
  end

  test 'drilldown candidates must be shown if credits exist' do
    create_post(:with_credit,
                site: @current_site,
                title: 'the post of the current site',
                body: 'contents...')

    visit '/'

    fill_in 'query[keywords]', with: 'contents'

    click_on '検索'

    within('main div.drilldown-participant') do
      assert_equal '絞り込み候補：', find('.drilldown-participant__label').text
      assert has_css?('.drilldown-participant__link')
    end
  end

  test 'drilldown candidates must not be shown if credits do not exist' do
    create_post(site: @current_site,
                title: 'the post of the current site',
                body: 'contents...')

    visit '/'

    fill_in 'query[keywords]', with: 'contents'

    click_on '検索'

    within('main div.drilldown-participant') do
      assert_false has_css?('.drilldown-participant__label')
      assert_false has_css?('.drilldown-participant__link')
    end
  end

  private

  def create_post(*attributes)
    post = create(:post, :whatever, *attributes)
    @indexer.add(post)
    post
  end
end
