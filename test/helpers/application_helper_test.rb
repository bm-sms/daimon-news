require "test_helper"

class ApplicationHelperTest < ActionView::TestCase
  include ApplicationHelper

  sub_test_case "render_markdown" do
    sub_test_case "autolink" do
      def test_simple
        markdown = <<~MARKDOWN
        http://www.example.com
        MARKDOWN
        expected_html = <<~HTML
        <p><a href="http://www.example.com">http://www.example.com</a></p>
        HTML
        html = render_markdown(markdown)
        assert_equal(expected_html, html)
      end

      def test_2_link_in_one_line
        markdown = <<~MARKDOWN
        http://www.example.com http://www.example.com
        MARKDOWN
        expected_html = <<~HTML
        <p><a href="http://www.example.com">http://www.example.com</a> <a href="http://www.example.com">http://www.example.com</a></p>
        HTML
        html = render_markdown(markdown)
        assert_equal(expected_html, html)
      end

      def test_with_text
        markdown = <<~MARKDOWN
        text http://www.example.com text
        MARKDOWN
        expected_html = <<~HTML
        <p>text <a href="http://www.example.com">http://www.example.com</a> text</p>
        HTML
        html = render_markdown(markdown)
        assert_equal(expected_html, html)
      end

      def test_with_underbar
        markdown = <<~MARKDOWN
        http://www.example.com/_example_ text
        MARKDOWN
        expected_html = <<~HTML
        <p><a href="http://www.example.com/_example_">http://www.example.com/_example_</a> text</p>
        HTML
        html = render_markdown(markdown)
        assert_equal(expected_html, html)
      end

      def test_multiple_links
        markdown = <<~MARKDOWN
        http://www.example.com
        http://www.example.com
        http://www.example.com
        MARKDOWN
        expected_html = <<~HTML
        <p><a href="http://www.example.com">http://www.example.com</a><br />
        <a href="http://www.example.com">http://www.example.com</a><br />
        <a href="http://www.example.com">http://www.example.com</a></p>
        HTML
        html = render_markdown(markdown)
        assert_equal(expected_html, html)
      end
    end
  end
end
