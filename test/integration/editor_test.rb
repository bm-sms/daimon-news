require "test_helper"

class EditorTest < ActionDispatch::IntegrationTest
  setup do
    @site = create(:site)
    editor = create(:user, sites: [@site])
    login_as_editor(site: @site, editor: editor)
  end

  test "Category" do
    click_on "カテゴリ"
    click_on "New Category"

    fill_in "Name",        with: "Ruby"
    fill_in "Description", with: "Ruby is a programming language."
    fill_in "Slug",        with: "ruby"
    fill_in "Order",       with: "1"

    click_on "登録する"

    assert(page.has_css?("p", text: "Name: Ruby"))

    click_on "Back"

    within :row, "Ruby" do
      click_on "Edit"
    end

    fill_in "Name", with: "Ruby lang"

    click_on "更新する"

    assert(page.has_css?("p", text: "Name: Ruby lang"))

    click_on "Back"

    within :row, "Ruby lang" do
      click_on "Destroy"
    end

    assert_equal("/sites/#{@site.id}/editor/categories", page.current_path)
    assert_not(page.has_css?("td", text: "Ruby lang"))
  end

  test "Serial" do
    click_on "連載"
    click_on "New Serial"

    fill_in "Title", with: "Ruby"
    fill_in "Description", with: "Ruby is a programming language."
    attach_file "Thumbnail", Rails.root.join("test/fixtures/images/thumbnail.jpg")

    click_on "登録する"

    assert(page.has_css?("p", text: "Title: Ruby"))

    click_on "Back"

    within :row, "Ruby" do
      click_on "Edit"
    end

    fill_in "Title", with: "Ruby lang"

    click_on "更新する"

    assert(page.has_css?("p", text: "Title: Ruby lang"))

    click_on "Back"

    within :row, "Ruby lang" do
      click_on "Destroy"
    end

    assert_equal("/sites/#{@site.id}/editor/serials", page.current_path)
    assert_not(page.has_css?("td", text: "Ruby lang"))
  end

  test "Participant" do
    click_on "執筆関係者"
    click_on "New Participant"

    fill_in "Name", with: "Ruby"
    fill_in "Description", with: "Ruby is a programing language."

    click_on "登録する"

    assert(page.has_css?("p", text: "Name: Ruby"))

    click_on "Back"

    within :row, "Ruby" do
      click_on "Edit"
    end

    fill_in "Name", with: "Ruby lang"

    click_on "更新する"

    assert(page.has_css?("p", text: "Name: Ruby lang"))

    click_on "Back"

    within :row, "Ruby lang" do
      click_on "Destroy"
    end

    assert_equal("/sites/#{@site.id}/editor/participants", page.current_path)
    assert_not(page.has_css?("td", text: "Ruby lang"))
  end

  test "Fixed Page" do
    click_on "固定ページ"

    click_on "New Fixed page"

    fill_in "Title", with: "Ruby"
    fill_in "Body",  with: "Ruby is a programming language."
    fill_in "Slug",  with: "ruby"

    click_on "登録する"

    assert(page.has_css?("p", text: "Title: Ruby"))

    click_on "Back"

    within :row, "Ruby" do
      click_on "Edit"
    end

    fill_in "Title", with: "Ruby lang"

    click_on "更新する"

    assert(page.has_css?("p", text: "Title: Ruby lang"))

    click_on "Back"

    within :row, "Ruby lang" do
      click_on "Destroy"
    end

    assert_equal("/sites/#{@site.id}/editor/fixed_pages", page.current_path)
    assert_not(page.has_css?("td", text: "Ruby lang"))
  end

  test "Link" do
    click_on "リンク"

    click_on "New Link"

    fill_in "Text",  with: "Ruby"
    fill_in "Url",   with: "http://example.com"
    fill_in "Order", with: "1"

    click_on "登録する"

    assert(page.has_css?("p", text: "Text: Ruby"))

    click_on "Back"

    within :row, "Ruby" do
      click_on "Edit"
    end

    fill_in "Text", with: "Ruby lang"

    click_on "更新する"

    assert(page.has_css?("p", text: "Text: Ruby lang"))

    click_on "Back"

    within :row, "Ruby lang" do
      click_on "Destroy"
    end

    assert_equal("/sites/#{@site.id}/editor/links", page.current_path)
    assert_not(page.has_css?("td", text: "Ruby lang"))
  end

  test "Credit role" do
    click_on "役割"

    click_on "New Credit role"

    fill_in "Name",  with: "Author"
    fill_in "Order", with: "1"

    click_on "登録する"

    assert(page.has_css?("p", text: "Name: Author"))

    click_on "Back"

    within :row, "Author" do
      click_on "Edit"
    end

    fill_in "Name", with: "Reviewer"

    click_on "更新する"

    assert(page.has_css?("p", text: "Name: Reviewer"))

    click_on "Back"

    within :row, "Reviewer" do
      click_on "Destroy"
    end

    assert_equal("/sites/#{@site.id}/editor/credit_roles", page.current_path)
    assert_not(page.has_css?("td", text: "Reviewer"))
  end

  test "preview post" do
    @post = create(:post, :whatever, :with_credit, site: @site, body: '# title')
    visit "/sites/#{@site.id}/editor/posts/#{@post.public_id}/preview"
    within ".post__body" do
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
      click_on "記事"

      click_on "New Post"

      fill_in "Title", with: "Ruby"
      fill_in "Body",  with: "Ruby is a programming language."
      select @category.name, from: "post_category_id"
      attach_file "Thumbnail", File.join(fixture_path, "images/daimon.png")

      click_on "登録する"

      assert(page.has_css?("p", text: "Title: Ruby"))
      # Participants
      within "main ul" do
        assert(find_all("li").empty?)
      end
      assert(page.has_css?("p", text: "Category: #{@category.name}"))
      assert(page.has_css?("p", text: "Serial:"))

      click_on "Back"

      within :row, "Ruby" do
        click_on "Edit"
      end

      fill_in "Title", with: "Ruby lang"

      click_on "更新する"

      assert(page.has_css?("p", text: "Title: Ruby lang"))

      click_on "Back"

      within :row, "Ruby lang" do
        click_on "Destroy"
      end

      assert_equal("/sites/#{@site.id}/editor/posts", page.current_path)
      assert_not(page.has_css?("td", text: "Ruby lang"))
    end

    test "Post with serial" do
      click_on "記事"

      click_on "New Post"

      fill_in "Title", with: "Ruby"
      fill_in "Body",  with: "Ruby is a programming language."
      select @category.name, from: "post_category_id"
      select @serial.title, from: "post_serial_id"
      attach_file "Thumbnail", File.join(fixture_path, "images/daimon.png")

      click_on "登録する"

      assert(page.has_css?("p", text: "Title: Ruby"))
      # Participants
      within "main ul" do
        assert(find_all("li").empty?)
      end
      assert(page.has_css?("p", text: "Category: #{@category.name}"))
      assert(page.has_css?("p", text: "Serial: #{@serial.title}"))

      click_on "Back"

      within :row, "Ruby" do
        click_on "Edit"
      end

      fill_in "Title", with: "Ruby lang"

      click_on "更新する"

      assert(page.has_css?("p", text: "Title: Ruby lang"))

      click_on "Back"

      within :row, "Ruby lang" do
        click_on "Destroy"
      end

      assert_equal("/sites/#{@site.id}/editor/posts", page.current_path)
      assert_not(page.has_css?("td", text: "Ruby lang"))
    end
  end

  sub_test_case "Post: post.id != post.public_id" do
    test "edit and destroy existing post" do
      post = create(:post, :whatever, site: @site, public_id: 100_000, title: "title")
      click_on "記事"
      within :row, post.title do
        click_on "Edit"
      end

      fill_in "Title", with: "updated title"

      click_on "更新する"

      assert(page.has_css?("p", text: "Title: updated title"))

      click_on "Back"

      within :row, "updated title" do
        click_on "Destroy"
      end

      assert_equal("/sites/#{@site.id}/editor/posts", page.current_path)
      assert_not(page.has_css?("td", text: "updated title"))
    end

    test "edit and destroy existing post with credit" do
      post = create(:post, :whatever, :with_credit, site: @site, public_id: 100_000, title: "title")
      click_on "記事"
      within :row, post.title do
        click_on "Edit"
      end

      fill_in "Title", with: "updated title"

      click_on "更新する"

      assert(page.has_css?("p", text: "Title: updated title"))

      click_on "Back"

      within :row, "updated title" do
        click_on "Destroy"
      end

      assert_equal("/sites/#{@site.id}/editor/posts", page.current_path)
      assert_not(page.has_css?("td", text: "updated title"))
    end
  end
end
