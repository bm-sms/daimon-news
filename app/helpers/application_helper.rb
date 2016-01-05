module ApplicationHelper
  def render_markdown(markdown_text)
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML.new(hard_wrap: true))
    markdown.render(markdown_text)
  end

  def google_tag_manager(gtm_id)
    if gtm_id.present?
      render partial: 'google_tag_manager', locals: { gtm_id: gtm_id }
    end
  end

  def default_meta_tags
    {
      site: current_site.name,
      reverse: true,
      description: current_site.tagline,
    }
  end
end
