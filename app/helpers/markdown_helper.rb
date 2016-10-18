module MarkdownHelper
  def render_markdown(markdown_text)
    processor = DaimonMarkdown::Processor.new
    result = processor.call(markdown_text)
    result[:output].to_html.html_safe
  end

  def extract_plain_text(markdown_text)
    html = render_markdown(markdown_text.gsub(/#{Page::SEPARATOR}/, ""))
    Nokogiri::HTML(html).inner_text.gsub(/[[:space:]]+/, " ")
  end
end
