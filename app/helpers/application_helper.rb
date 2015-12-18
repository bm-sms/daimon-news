module ApplicationHelper
  def render_markdown(markdown_text)
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML)
    markdown.render(markdown_text)
  end

  def page_title
    title = current_site.name
    if @page_meta_information.try(:title)
      title = "#{@page_meta_information.title} | #{title}"
    end
    title
  end
end
