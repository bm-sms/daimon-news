require_dependency 'daimon/render/html'

module MarkdownHelper
  def render_markdown(markdown_text)
    markdown = Redcarpet::Markdown.new(Daimon::Render::HTML.new(hard_wrap: true),
                                       fenced_code_blocks: true,
                                       tables: true)
    markdown.render(markdown_text)
  end

  def extract_plain_text(markdown_text)
    html = render_markdown(markdown_text.gsub(/#{Page::SEPARATOR}/, ""))
    Nokogiri::HTML(html).inner_text.gsub(/[[:space:]]+/, " ")
  end
end
