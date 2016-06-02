require "test_helper"

class PostSerialTest < ActionDispatch::IntegrationTest
  setup do
    @post = create(:post, :whatever)
    switch_domain(@post.site.fqdn)
  end

  sub_test_case "belongs to serial" do
    setup do
      @serial_title = "Serial Title"
      create(:serial, title: @serial_title, posts: [@post], site: @post.site)
    end

    test "should display serial's title" do
      visit "/#{@post.public_id}"

      within ".post" do
        assert page.has_selector?(".post__serial--title", text: @serial_title)
      end
    end

    test "should display link to serial's index page" do
      visit "/#{@post.public_id}"

      within ".post" do
        assert page.has_selector?(".post__serial--index")
      end
    end
  end

  sub_test_case "doesn't belong to serial" do
    test "should not display serial's title" do
      visit "/#{@post.public_id}"

      within ".post" do
        assert page.has_no_selector?(".post__serial--title")
      end
    end

    test "should not display link to serial's index page" do
      visit "/#{@post.public_id}"

      within ".post" do
        assert page.has_no_selector?(".post__serial--index")
      end
    end
  end
end
