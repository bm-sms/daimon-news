require "test_helper"
require "daimon_markdown"
require "cgi/util"

class TocPagesTest < ActiveSupport::TestCase
  include CGI::Util

  sub_test_case "no toc" do
    test "no request" do
      markdown = <<~TEXT
      {{toc_pages}}

      # title

      This is a text.
      TEXT
      context = {}
      result = process_markdown(markdown, context)
      assert do
        result[:output].search(".section-nav").empty?
      end
    end
  end

  sub_test_case "toc" do
    test "single page" do
      post = create(:post, :whatever, :with_single_page_toc)

      markdown = <<~TEXT
        {{ toc_pages }}

        # title

        body

        ## title 2

        hello

        ## title 3

        world
      TEXT

      expected_toc_html = <<~HTML.chomp
      <ul class="section-nav">
      <li><a href="#title">title</a></li>
      <ul>
      <li><a href="#title-2">title 2</a></li>
      <li><a href="#title-3">title 3</a></li>
      </ul>
      </ul>
      HTML
      expected_header_ids = ["title", "title-2", "title-3"]
      context = {
        full_text: post.body,
        fullpath: "/#{post.public_id}",
      }
      assert_toc(expected_toc_html, expected_header_ids, markdown, context)
    end

    data(before: :with_pages_toc1,
         after: :with_pages_toc2,)
    test "multiple pages 1/3" do |trait_name|
      post = create(:post, :whatever, trait_name)

      markdown = post.body.split(/#{Regexp.quote(Page::SEPARATOR)}/)[0]

      expected_toc_html = <<~HTML.chomp
      <ul class="section-nav">
      <li><a href="#title">title</a></li>
      <ul>
      <li><a href="/#{post.public_id}?page=2#title-2">title 2</a></li>
      <li><a href="/#{post.public_id}?page=3#title-3">title 3</a></li>
      </ul>
      </ul>
      HTML
      expected_header_ids = ["title"]
      context = {
        full_text: post.body,
        fullpath: "/#{post.public_id}"
      }
      assert_toc(expected_toc_html, expected_header_ids, markdown, context)
    end

    data(before: :with_pages_toc1,
         after: :with_pages_toc2,)
    test "multiple pages 2/3" do |trait_name|
      post = create(:post, :whatever, trait_name)

      markdown = post.body.split(/#{Regexp.quote(Page::SEPARATOR)}/)[1]

      expected_toc_html = ""
      expected_header_ids = ["title-2"]
      context = {
        full_text: post.body,
        fullpath: "/#{post.public_id}",
        current_page: 2
      }
      assert_toc(expected_toc_html, expected_header_ids, markdown, context)
    end

    data(before: :with_pages_toc1,
         after: :with_pages_toc2,)
    test "multiple pages 3/3" do |trait_name|
      post = create(:post, :whatever, trait_name)

      markdown = post.body.split(/#{Regexp.quote(Page::SEPARATOR)}/)[2]

      expected_toc_html = ""
      expected_header_ids = ["title-3"]
      context = {
        full_text: post.body,
        fullpath: "/#{post.public_id}",
        current_page: 3
      }
      assert_toc(expected_toc_html, expected_header_ids, markdown, context)
    end

    data("page1" => [1, 0, ["title"]],
         "page2" => [2, 1, ["title-2"]],
         "page3" => [3, 2, ["title-3", "title-3-1", "title-3-2"]])
    test "multiple pages with complex source" do |(page, index, expected_header_ids)|
      body = <<~BODY
        {{ toc_pages }}

        # title

        body

        <!--nextpage-->

        {{ toc_pages }}

        text text text

        ## title 2

        hello

        <!--nextpage-->

        {{ toc_pages }}

        text text text

        ## title 3

        world

        ### title 3-1

        fizz

        ### title 3-2

        buzz
      BODY
      post = create(:post, :whatever, body: body)

      markdown = post.body.split(/#{Regexp.quote(Page::SEPARATOR)}/)[index]

      expected_toc_html = <<~HTML.chomp
      <ul class="section-nav">
      <li><a href="#title">title</a></li>
      <ul>
      <li><a href="/#{post.public_id}?page=2#title-2">title 2</a></li>
      <li><a href="/#{post.public_id}?page=3#title-3">title 3</a></li>
      <ul>
      <li><a href="/#{post.public_id}?page=3#title-3-1">title 3-1</a></li>
      <li><a href="/#{post.public_id}?page=3#title-3-2">title 3-2</a></li>
      </ul>
      </ul>
      </ul>
      HTML
      expected_toc_html = "" if page > 1
      context = {
        full_text: post.body,
        fullpath: "/#{post.public_id}",
      }
      context[:current_page] = page if page > 1
      assert_toc(expected_toc_html, expected_header_ids, markdown, context)
    end
  end

  private

  def process_markdown(markdown, context = {})
    processor = DaimonMarkdown::Processor.new
    processor.call(markdown, context)
  end

  def assert_toc(expected_toc_html, expected_header_ids, markdown, context = {})
    result = process_markdown(markdown, context)
    actual_toc_html = result[:output].search("ul").first.to_s
    actual_header_ids = result[:output].search("h1, h2, h3, h4, h5, h6").map {|node| node["id"] }.compact
    assert_equal(expected_toc_html, actual_toc_html)
    assert_equal(expected_header_ids, actual_header_ids)
    result
  end

  class DummyRequest
    attr_reader :server_name, :fullpath, :params

    def initialize(server_name: "example.com", params: {})
      @server_name = server_name
      @params = params
      @fullpath = "/#{params[:public_id]}"
    end
  end
end
