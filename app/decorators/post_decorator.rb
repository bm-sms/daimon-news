module PostDecorator
  def short_text_body
    truncate(plain_text_body, length: 140)
  end

  def to_meta_description
    short_text_body
  end

  def to_og_params
    {
      locale: 'ja_JP',
      type: 'article',
      title: title,
      description: MetaTags::TextNormalizer.normalize_description(render_markdown(body)),
      url: post_url(self, all: true),
      site_name: site.name,
      modified_time: updated_at.iso8601,
      image: thumbnail_url
    }
  end

  def to_article_params
    {
      section: category.name,
      published_time: published_at&.iso8601
    }
  end

  def plain_text_body
    @plain_text_body ||= extract_plain_text(body)
  end

  def display_credits?(pages)
    return false unless credits.present?
    pages.current_page == 1
  end
end
