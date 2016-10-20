module MarkdownHelper
  def render_markdown(markdown_text)
    Rails.cache.fetch([:post, :markdown_body, Digest::MD5.hexdigest(markdown_text)]) do
      processor = DaimonMarkdown::Processor.new
      result = processor.call(markdown_text)
      result[:output].to_html.html_safe
    end
  end

  def extract_plain_text(markdown_text)
    html = render_markdown(markdown_text.gsub(/#{Regexp.quote(Page::SEPARATOR)}/, ""))
    Nokogiri::HTML(html).inner_text.gsub(/[[:space:]]+/, " ")
  end
end
