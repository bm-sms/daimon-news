module ApplicationHelper
  def render_markdown(markdown_text)
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML)
    markdown.render(markdown_text)
  end
end
