module MarkdownHelper
  def render_markdown(markdown_text)
    processor = Daimon::Markdown::Processor.new
    result = processor.call(markdown_text)
    result[:output].to_html
  rescue => ex
    Rails.logger.warn("#{ex.class}: #{ex.message}\n#{ex.backtrace.join("\n")}")
    markdown_text
  end

  def extract_plain_text(markdown_text)
    html = render_markdown(markdown_text.gsub(/#{Page::SEPARATOR}/, ""))
    Nokogiri::HTML(html).inner_text.gsub(/[[:space:]]+/, " ")
  end
end
