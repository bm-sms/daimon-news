require "test_helper"

class ParticipantTest < ActionDispatch::IntegrationTest
  setup do
    @site = create(:site)
    @participants = create_list(:participant, 3, :with_photo, :with_posts, site: @site)

    switch_domain(@site.fqdn)
  end

  sub_test_case "/participants" do
    test "page title" do
      visit("/participants")

      assert_equal("すべての執筆関係者 | #{@site.name}", title)
    end

    test "page title with pagination" do
      create_list(:participant, 50, :with_posts, site: @site)

      visit("/participants?page=2")

      assert_equal("すべての執筆関係者 (26〜50/#{Participant.having_published_posts.count}件) | #{@site.name}", title)
    end

    test "participant titles" do
      visit "/participants"

      participant_titles = find_all(".participant-summary__title")
      assert_equal(@participants.map(&:name).sort, participant_titles.map(&:text))
    end

    test "number of posts" do
      visit("/participants")

      number_of_posts = find_all(".number-of-posts")
      assert_equal(["記事数：1", "記事数：1", "記事数：1"], number_of_posts.map(&:text))
    end

    test "markdown" do
      create(:participant, :with_posts, site: @site, summary: "This is a summary")
      visit("/participants")

      description = find_all(".participant-summary__content").last
      assert_equal("This is a summary", description.text)
    end
  end

  sub_test_case "/participants/:id" do
    test "page title" do
      visit("/participants")

      click_on(@participants.last.name)

      assert_equal("#{@participants.last.name} | #{@site.name}", title)
    end

    test "participant title" do
      visit("/participants")

      click_on(@participants.last.name)

      title = find(".participant-content__title")
      assert_equal(@participants.last.name, title.text)
    end

    test "participant description" do
      participant = create(:participant, :with_posts, name: "participant name", site: @site, description: <<~DESC)
        # This is title

        contents
      DESC
      visit("/participants")

      click_on(participant.name)

      within ".participant-content__description" do
        h1 = find("h1")
        assert_equal("This is title", h1.text)
        contents = find("p")
        assert_equal("contents", contents.text)
      end
    end
  end
end
