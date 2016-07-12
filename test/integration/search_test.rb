require "test_helper"

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

  test "posts of other sites should not be shown" do
    create_post(site: @current_site,
                title: "the post of the current site",
                body: "contents...")
    create_post(site: @other_site,
                title: "the post of the other site",
                body: "contents...")

    visit "/"

    fill_in "query[keywords]", with: "contents"

    click_on "検索"

    within("main") do
      assert_equal "「contents」を含む記事が1件見つかりました。", find(".message").text
      within("ul") do
        assert find_link("the post of the current site")
      end
    end

    within("aside") do
      assert_equal "contents", find("#query_keywords").value
    end
  end

  test "unpublished posts should not be shown" do
    create_post(site: @current_site,
                title: "post1 is published",
                body: "body...")
    create_post(site: @current_site,
                title: "post2 is not published",
                body: "body...",
                published_at: 1.hour.from_now)
    create_post(site: @current_site,
                title: "post3 is published",
                body: "body...")
    stopped_publishing_post = create_post(site: @current_site,
                                          title: "post4 is stopped publishing",
                                          body: "body...")
    stopped_publishing_post.published_at = nil
    stopped_publishing_post.save!

    visit "/"

    fill_in "query[keywords]", with: "body"

    click_on "検索"

    within("main") do
      # NOTE: 記事が公開されてから非公開になった場合、Groongaのデータベースが更新されるまでは件数がずれる。
      # ref: https://github.com/bm-sms/daimon-news-multi-tenant/pull/365#issuecomment-200634038

      within("ul.search-result-list") do
        assert has_content?("post1 is published")
        assert has_no_content?("post2 is not published")
        assert has_content?("post3 is published")
      end
    end
  end

  test "the highest score post should appear in the top" do
    create_post(site: @current_site,
                title: "post1 BBB",
                body: "AAA...",
                published_at: 1.hour.ago)
    create_post(site: @current_site,
                title: "post2 AAA",
                body: "AAA...",
                published_at: 2.hour.ago)
    create_post(site: @current_site,
                title: "post3 AAA",
                body: "BBB...",
                published_at: 3.hour.ago)

    visit "/"

    fill_in "query[keywords]", with: "AAA"

    click_on "検索"

    within("main") do
      assert_equal "「AAA」を含む記事が3件見つかりました。", find(".message").text
      within("ul.search-result-list") do
        assert_equal([
                       "post2 AAA", # The highest score post; title and body has the keyword "AAA".
                       "post3 AAA", # The second highest score post; title has the keyword "AAA".
                       "post1 BBB", # The third highest score post; body has the keyword "AAA".
                     ],
                     all(".article-summary__title").map(&:text))
      end
    end
  end

  test "search results should be empty when keyword is empty" do
    create_post(:with_credit,
                site: @current_site,
                title: "post1",
                body: "contents...")

    visit "/"

    fill_in "query[keywords]", with: ""

    click_on "検索"

    within("main") do
      assert_equal "", find(".message").text
      within(".search-result-list") do
        assert page.has_css?(".article-summary__title", text: "post1")
      end
    end
  end

  test "keywords should be split for all target columns" do
    create_post(:with_credit,
                site: @current_site,
                title: "post1",
                body: "contents...")

    visit "/"

    fill_in "query[keywords]", with: "post contents author description"

    click_on "検索"

    within("main") do
      assert_equal "「post contents author description」を含む記事が1件見つかりました。", find(".message").text
    end
  end

  sub_test_case "meta data" do
    test "no result" do
      visit "/"

      fill_in "query[keywords]", with: "a"

      click_on "検索"

      assert_equal "aの検索結果(0件) | #{@current_site.name}", title
      assert_equal "aの検索結果(0件) | #{@current_site.name}", find('meta[property="og:title"]', visible: false)["content"]
      assert_equal "「a」を含む記事は見つかりませんでした。", find("meta[name=description]", visible: false)["content"]
      assert_equal({"page" => "1", "query" => {"keywords" => "a"}}, canonical_params)
      assert_equal "noindex", find("meta[name=robots]", visible: false)["content"]
    end

    test "with pagenation" do
      keywords = 51.times.map { create_post(site: @current_site) }.first.title

      visit "/"

      fill_in "query[keywords]", with: keywords

      click_on "検索"

      assert_equal "#{keywords}の検索結果(1〜50/51件) | #{@current_site.name}", title
      assert_equal "#{keywords}の検索結果(1〜50/51件) | #{@current_site.name}", find('meta[property="og:title"]', visible: false)["content"]
      assert_equal "「#{keywords}」を含む記事が51件見つかりました。(1〜50/51件)", find("meta[name=description]", visible: false)["content"]
      assert_equal({"page" => "1", "query" => {"keywords" => keywords}}, canonical_params)
      assert_equal "noindex", find("meta[name=robots]", visible: false)["content"]
    end

    test "without pagenation" do
      keywords = create_post(site: @current_site).title

      visit "/"

      fill_in "query[keywords]", with: keywords

      click_on "検索"

      assert_equal "#{keywords}の検索結果(1件) | #{@current_site.name}", title
      assert_equal "「#{keywords}」を含む記事が1件見つかりました。", find("meta[name=description]", visible: false)["content"]
      assert_equal({"page" => "1", "query" => {"keywords" => keywords}}, canonical_params)
      assert_equal "noindex", find("meta[name=robots]", visible: false)["content"]
    end
  end

  sub_test_case "markdown" do
    setup do
      create_post(site: @current_site,
                  title: "post1",
                  body: <<~BODY)
      # This is a title

      contents contents contents contents

      * item1
        * item2
          * item3

      ## h2 title

      contents contents **strong contents** contents

      - item4
        - item5
          - item6

      BODY
    end

    data("#" => "#",
         "##" => "##",
         "*" => "*",
         "**" => "**",
         "-" => "-",
         "----" => "----",
         "unmatch1-unmatch2" => "unmatch1-unmatch2",
         "unmatch1 -unmatch2" => "unmatch1 -unmatch2",
         "unmatch1 - unmatch2" => "unmatch1 - unmatch2")
    test "markdown characters should not be matched" do |data|
      visit "/"

      fill_in "query[keywords]", with: data

      click_on "検索"

      within("main") do
        assert_equal "「#{data}」を含む記事は見つかりませんでした。", find(".message").text
      end
    end
  end

  sub_test_case "operator" do
    setup do
      create_post(site: @current_site,
                  title: "operators",
                  body: <<~BODY)
      # operators

      `+ - -a ~ ( ) < >`
      BODY
    end

    data("+" => "+",
         "-" => "-",
         "-a" => "-a",
         "~" => "~",
         "(" => "(",
         ")" => ")",
         "<" => "<",
         ">" => ">")
    test "operators should be as-is" do |data|
      visit "/"

      fill_in "query[keywords]", with: data

      click_on "検索"

      within("main") do
        assert_equal "「#{data}」を含む記事が1件見つかりました。", find(".message").text
      end
    end
  end

  sub_test_case "snippets" do
    setup do
      create_post(site: @current_site,
                  title: "post1",
                  body: <<~BODY)
      # This is a title

      contents contents contents contents
      contents contents contents contents
      contents contents contents contents
      contents contents contents contents

      * item1
        * item2
          * item3

      ## h2 title

      contents contents **strong contents** contents
      contents contents **strong contents** contents
      contents contents **strong contents** contents
      contents contents **strong contents** contents

      - item4
        - item5
          - item6

      BODY
    end

    test "display truncated body when snippets is empty" do
      visit "/"

      fill_in "query[keywords]", with: "post1"

      click_on "検索"

      within("main") do
        assert_equal "「post1」を含む記事が1件見つかりました。", find(".message").text
        expected = "This is a title contents contents contents contents contents contents contents contents contents contents contents contents contents cont..."
        assert_equal expected, find(".search-result").text
      end
    end

    data(
      "title" => {
        query: "title",
        highlighted: ["title", "title"]
      },
      "participant info" => {
        query: "Author",
        highlighted: ["Author", "Author"]
      }
    )
    test "display snippets when snippets is not empty" do |data|
      query = data[:query]
      highlighted = data[:highlighted]
      visit "/"

      fill_in "query[keywords]", with: query

      click_on "検索"

      within("main") do
        assert_equal "「#{query}」を含む記事が1件見つかりました。", find(".message").text
        within(".search-result") do
          assert_equal(highlighted, all(".search-result__keyword").map(&:text))
        end
      end
    end
  end

  private

  def canonical_params
    Rack::Utils.parse_nested_query(URI.parse(find("link[rel=canonical]", visible: false)["href"]).query)
  end
end
