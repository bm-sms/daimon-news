module MarkdownHelper
  def render_markdown(markdown_text)
    context = {}
    if defined?(request)
      context[:request] = request
    end
    processor = DaimonMarkdown::Processor.new(context)
    result = processor.call(markdown_text)
    result[:output].to_html.html_safe
  end

  def extract_plain_text(markdown_text)
    html = render_markdown(markdown_text.gsub(/#{Regexp.quote(Page::SEPARATOR)}/, ""))
    Nokogiri::HTML(html).inner_text.gsub(/[[:space:]]+/, " ")
  end
end

require "daimon_markdown/plugins/toc_pages"
