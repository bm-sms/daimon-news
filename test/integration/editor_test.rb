require "test_helper"

class EditorTest < ActionDispatch::IntegrationTest
  setup do
    @site = create(:site)
    editor = create(:user, sites: [@site])
    login_as_editor(site: @site, editor: editor)
  end

  test "Category" do
    click_on("カテゴリ")
    click_on("New Category")

    fill_in("Name",        with: "Ruby")
    fill_in("Description", with: "Ruby is a programming language.")
    fill_in("Slug",        with: "ruby")

    click_on("登録する")

    assert(page.has_css?("p", text: "Name: Ruby"))

    click_on("Back")

    within(:row, "Ruby") do
      click_on("Edit")
    end

    fill_in("Name", with: "Ruby lang")

    click_on("更新する")

    assert(page.has_css?("p", text: "Name: Ruby lang"))

    click_on("Back")

    within(:row, "Ruby lang") do
      click_on("Destroy")
    end

    assert_equal("/editor/categories", page.current_path)
    assert_not(page.has_css?("td", text: "Ruby lang"))
  end

  test "Serial" do
    click_on("連載")
    click_on("New Serial")

    fill_in("Title", with: "Ruby")
    fill_in("Description", with: "Ruby is a programming language.")
    attach_file("Thumbnail", Rails.root.join("test/fixtures/images/thumbnail.jpg"))

    click_on("登録する")

    assert(page.has_css?("p", text: "Title: Ruby"))

    click_on("Back")

    within(:row, "Ruby") do
      click_on("Edit")
    end

    fill_in("Title", with: "Ruby lang")

    click_on("更新する")

    assert(page.has_css?("p", text: "Title: Ruby lang"))

    click_on("Back")

    within(:row, "Ruby lang") do
      click_on("Destroy")
    end

    assert_equal("/editor/serials", page.current_path)
    assert_not(page.has_css?("td", text: "Ruby lang"))
  end

  test "Participant" do
    click_on("執筆関係者")
    click_on("New Participant")

    fill_in("Name", with: "Ruby")
    fill_in("Summary", with: "Ruby is a programing language.")

    click_on("登録する")

    assert(page.has_css?("p", text: "Name: Ruby"))

    click_on("Back")

    within(:row, "Ruby") do
      click_on("Edit")
    end

    fill_in("Name", with: "Ruby lang")

    click_on("更新する")

    assert(page.has_css?("p", text: "Name: Ruby lang"))

    click_on("Back")

    within(:row, "Ruby lang") do
      click_on("Destroy")
    end

    assert_equal("/editor/participants", page.current_path)
    assert_not(page.has_css?("td", text: "Ruby lang"))
  end

  test "Fixed Page" do
    click_on("固定ページ")

    click_on("New Fixed page")

    fill_in("Title", with: "Ruby")
    fill_in("Body",  with: "Ruby is a programming language.")
    fill_in("Slug",  with: "ruby")

    click_on("登録する")

    assert(page.has_css?("p", text: "Title: Ruby"))

    click_on("Back")

    within(:row, "Ruby") do
      click_on("Edit")
    end

    fill_in("Title", with: "Ruby lang")

    click_on("更新する")

    assert(page.has_css?("p", text: "Title: Ruby lang"))

    click_on("Back")

    within(:row, "Ruby lang") do
      click_on("Destroy")
    end

    assert_equal("/editor/fixed_pages", page.current_path)
    assert_not(page.has_css?("td", text: "Ruby lang"))
  end

  test "Link" do
    click_on("リンク")

    click_on("New Link")

    fill_in("Text",  with: "Ruby")
    fill_in("Url",   with: "http://example.com")
    fill_in("Order", with: "1")

    click_on("登録する")

    assert(page.has_css?("p", text: "Text: Ruby"))

    click_on("Back")

    within(:row, "Ruby") do
      click_on("Edit")
    end

    fill_in("Text", with: "Ruby lang")

    click_on("更新する")

    assert(page.has_css?("p", text: "Text: Ruby lang"))

    click_on("Back")

    within(:row, "Ruby lang") do
      click_on("Destroy")
    end

    assert_equal("/editor/links", page.current_path)
    assert_not(page.has_css?("td", text: "Ruby lang"))
  end

  test "preview post" do
    @post = create(:post, :whatever, :with_credit, site: @site, body: '# title')
    visit("/editor/posts/#{@post.public_id}/preview")
    within(".post__body") do
      assert_equal("title", find("h1").text)
    end
  end

  sub_test_case "Post" do
    setup do
      @category = create(:category, site: @site)
      @serial = create(:serial, site: @site)
      @participant = create(:participant, site: @site)
      @credit_role = create(:credit_role, site: @site)
    end

    test "Post" do
      click_on("記事")

      click_on("New Post")

      fill_in("Title", with: "Ruby")
      fill_in("Body",  with: "Ruby is a programming language.")
      select(@category.name, from: "post_category_id")
      attach_file("Thumbnail", File.join(fixture_path, "images/daimon.png"))

      click_on("登録する")

      assert(page.has_css?("p", text: "Title: Ruby"))
      # Participants
      within("main ul") do
        assert(find_all("li").empty?)
      end
      assert(page.has_css?("p", text: "Category: #{@category.name}"))
      assert(page.has_css?("p", text: "Serial:"))

      click_on("Back")

      within(:row, "Ruby") do
        click_on("Edit")
      end

      fill_in("Title", with: "Ruby lang")

      click_on("更新する")

      assert(page.has_css?("p", text: "Title: Ruby lang"))

      click_on("Back")

      within(:row, "Ruby lang") do
        click_on("Destroy")
      end

      assert_equal("/editor/posts", page.current_path)
      assert_not(page.has_css?("td", text: "Ruby lang"))
    end

    test "Post with serial" do
      click_on("記事")

      click_on("New Post")

      fill_in("Title", with: "Ruby")
      fill_in("Body",  with: "Ruby is a programming language.")
      select(@category.name, from: "post_category_id")
      select(@serial.title, from: "post_serial_id")
      attach_file("Thumbnail", File.join(fixture_path, "images/daimon.png"))

      click_on("登録する")

      assert(page.has_css?("p", text: "Title: Ruby"))
      # Participants
      within("main ul") do
        assert(find_all("li").empty?)
      end
      assert(page.has_css?("p", text: "Category: #{@category.name}"))
      assert(page.has_css?("p", text: "Serial: #{@serial.title}"))

      click_on("Back")

      within(:row, "Ruby") do
        click_on("Edit")
      end

      fill_in("Title", with: "Ruby lang")

      click_on("更新する")

      assert(page.has_css?("p", text: "Title: Ruby lang"))

      click_on("Back")

      within(:row, "Ruby lang") do
        click_on("Destroy")
      end

      assert_equal("/editor/posts", page.current_path)
      assert_not(page.has_css?("td", text: "Ruby lang"))
    end
  end

  sub_test_case "Post: post.id != post.public_id" do
    test "edit and destroy existing post" do
      post = create(:post, :whatever, site: @site, public_id: 100_000, title: "title")
      click_on("記事")
      within(:row, post.title) do
        click_on("Edit")
      end

      fill_in("Title", with: "updated title")

      click_on("更新する")

      assert(page.has_css?("p", text: "Title: updated title"))

      click_on("Back")

      within(:row, "updated title") do
        click_on("Destroy")
      end

      assert_equal("/editor/posts", page.current_path)
      assert_not(page.has_css?("td", text: "updated title"))
    end

    test "edit and destroy existing post with credit" do
      post = create(:post, :whatever, :with_credit, site: @site, public_id: 100_000, title: "title")
      click_on("記事")
      within(:row, post.title) do
        click_on("Edit")
      end

      fill_in("Title", with: "updated title")

      click_on("更新する")

      assert(page.has_css?("p", text: "Title: updated title"))

      click_on("Back")

      within(:row, "updated title") do
        click_on("Destroy")
      end

      assert_equal("/editor/posts", page.current_path)
      assert_not(page.has_css?("td", text: "updated title"))
    end
  end

  sub_test_case "Category hierarchy" do
    setup do
      @categories = create_list(:category, 5, site: @site)
    end

    test "move to higher" do
      click_on("カテゴリ")
      within(:row, @categories[4].name) do
        click_on("▲")
      end
      names = find_all("tr.depth0").map do |tr|
        tr.first("td").text
      end
      expected = @categories.values_at(0, 1, 2, 4, 3).map(&:name)
      assert_equal(expected, names)
    end

    test "move to lower" do
      click_on("カテゴリ")
      within(:row, @categories[1].name) do
        click_on("▼")
      end
      names = find_all("tr.depth0").map do |tr|
        tr.first("td").text
      end
      expected = @categories.values_at(0, 2, 1, 3, 4).map(&:name)
      assert_equal(expected, names)
    end

    test "append children" do
      pend "TODO: release this feature"

      click_on("カテゴリ")
      click_on("New Category")

      fill_in("Name",        with: "Ruby")
      fill_in("Description", with: "Ruby is a programming language.")
      fill_in("Slug",        with: "ruby")
      select(@categories[0].name, from: "category_parent_id")

      click_on("登録する")

      click_on("Back")

      assert_equal("depth1", find("tr", text: "Ruby")[:class])
      within(:row, "Ruby") do
        assert_false(find("td", text: "▲").has_css?("a"))
        assert_false(find("td", text: "▼").has_css?("a"))
      end

      click_on("New Category")

      fill_in("Name",        with: "Python")
      fill_in("Description", with: "Python is a programming language.")
      fill_in("Slug",        with: "python")
      select(@categories[0].name, from: "category_parent_id")

      click_on("登録する")

      click_on("Back")

      assert_equal("depth1", find("tr", text: "Python")[:class])
      within(:row, "Ruby") do
        assert_false(find("td", text: "▲").has_css?("a"))
        assert_true(find("td", text: "▼").has_css?("a"))
      end
      within(:row, "Python") do
        assert_true(find("td", text: "▲").has_css?("a"))
        assert_false(find("td", text: "▼").has_css?("a"))
        click_on("▲")
      end

      within(:row, "Ruby") do
        assert_true(find("td", text: "▲").has_css?("a"))
        assert_false(find("td", text: "▼").has_css?("a"))
      end
      within(:row, "Python") do
        assert_false(find("td", text: "▲").has_css?("a"))
        assert_true(find("td", text: "▼").has_css?("a"))
      end

      click_on("New Category")

      fill_in("Name",        with: "JRuby")
      fill_in("Description", with: "JRuby is an implementation of Ruby.")
      fill_in("Slug",        with: "jruby")
      select("Ruby", from: "category_parent_id")
      click_on("登録する")

      click_on("Back")

      assert_equal("depth2", find("tr", text: "JRuby")[:class])
      within(:row, "JRuby") do
        assert_false(find("td", text: "▲").has_css?("a"))
        assert_false(find("td", text: "▼").has_css?("a"))
      end
    end
  end

  sub_test_case "category hierarchy multiple sites" do
    setup do
      pend "TODO: release this feature"

      site2 = create(:site)
      @categories1 = []
      @categories2 = []
      @categories1 << create(:category, name: "Ruby", order: 1, site: @site)
      @categories2 << create(:category, name: "Perl", order: 1, site: site2)
      @categories1 << create(:category, name: "mruby", order: 2, site: @site)
      @categories2 << create(:category, name: "PHP", order: 2, site: site2)
      @categories1 << create(:category, name: "Opal", order: 3, site: @site)
      @categories2 << create(:category, name: "Python", order: 3, site: site2)
      @categories1 << create(:category, name: "JRuby", order: 4, site: @site)
      @categories2 << create(:category, name: "Cython", order: 4, site: site2)
      @categories1 << create(:category, name: "Rubinius", order: 5, site: @site)
      @categories2 << create(:category, name: "Jython", order: 5, site: site2)
    end

    test "move to higher" do
      click_on("カテゴリ")
      within(:row, @categories1[4].name) do
        click_on("▲")
      end
      names = find_all("tr.depth0").map do |tr|
        tr.first("td").text
      end
      expected = @categories1.values_at(0, 1, 2, 4, 3).map(&:name)
      assert_equal(expected, names)
    end

    test "move to lower" do
      click_on("カテゴリ")
      within(:row, @categories1[1].name) do
        click_on("▼")
      end
      names = find_all("tr.depth0").map do |tr|
        tr.first("td").text
      end
      expected = @categories1.values_at(0, 2, 1, 3, 4).map(&:name)
      assert_equal(expected, names)
    end
  end
end
