module ApplicationHelper
  def render_markdown(markdown_text)
    document = Kramdown::Document.new(markdown_text,
                                      input: "GFM",
                                      syntax_highlighter: "rouge",
                                      hard_wrap: true)
    document.to_html
  end

  #
  # format: <parser>:<formatter>
  #   <parser>: r -> reverse_markdown
  #             k -> kramdown
  #             p -> pandoc
  #   <formatter>: k -> kramdown
  #                r -> redcarpet
  #                p -> pandoc
  def render_markdown_text(post, format: "r:k")
    parser, formatter = format.split(":")
    parser_map = {
      "r" => post.reverse_markdown_text,
      "k" => post.kramdown_text,
      "p" => post.markdown_text
    }
    text = parser_map[parser]
    case formatter
    when "k"
      document = Kramdown::Document.new(text,
                                        input: "GFM",
                                        syntax_highlighter: "rouge",
                                        hard_wrap: true)
      document.to_html
    when "r"
      markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML.new(hard_wrap: true), tables: true)
      markdown.render(text)
    when "p"
      # not tested
      extension = ""
      PandocRuby.convert(text.gsub(Page::SEPARATOR, "{{nextpage}}"),
                         {
                           from: "markdown_github#{extension}",
                           to: "html",
                         },
                         "atx-header").gsub("{{nextpage}}", Page::SEPARATOR)
    end
  end

  def google_tag_manager(gtm_id)
    if gtm_id.present?
      render partial: 'application/google_tag_manager', locals: { gtm_id: gtm_id }
    end
  end

  def default_meta_tags
    {
      site: current_site.name,
      reverse: true,
      description: current_site.tagline,
    }
  end

  def favicon_tag(site)
    if site.favicon_image.present?
      favicon_link_tag site.favicon_image_url
    elsif site.favicon_url.present?
      favicon_link_tag site.favicon_url
    end
  end

  def mobile_favicon_tag(site)
    if site.mobile_favicon_image.present?
      favicon_link_tag(site.mobile_favicon_image_url,
                       rel: 'apple-touch-icon-precomposed', type: 'image/png')
    elsif site.mobile_favicon_url.present?
      favicon_link_tag(site.mobile_favicon_url,
                       rel: 'apple-touch-icon-precomposed', type: 'image/png')
    end
  end
end
