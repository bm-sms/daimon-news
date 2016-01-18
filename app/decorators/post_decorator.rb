module PostDecorator
  def to_meta_description
    plain_text_body.first(140)
  end

  def to_og_params
    {
      locale: 'ja_JP',
      type: 'article',
      title: title,
      description: body,
      url: post_url(id, all: true),
      site_name: site.name,
      modified_time: updated_at.to_datetime.to_s,
      image: thumbnail_image_url || thumbnail_url
    }
  end

  def to_article_params
    {
      section: category.name,
      published_time: published_at.to_datetime.to_s
    }
  end

  def thumbnail_image_tag(options={})
    case
    when thumbnail_image?
      image_tag thumbnail_image_url(:thumb), options
    when thumbnail_url.present?
      image_tag thumbnail_url, options
    else
      image_tag "/dummy.png", options
    end
  end

  private

  def plain_text_body
    @plain_text_body ||= strip_tags(render_markdown(body)).gsub(/[[:space:]]+/, ' ')
  end
end
