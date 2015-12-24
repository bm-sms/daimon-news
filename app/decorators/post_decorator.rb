module PostDecorator
  def to_og_params
    {
      locale: 'ja_JP',
      type: 'article',
      title: title,
      description: body,
      url: post_url(self, all: true),
      site_name: site.name,
      modified_time: updated_at.to_datetime.to_s,
      image: thumbnail_url
    }
  end

  def to_article_params
    {
      section: category.name,
      published_time: published_at.to_datetime.to_s
    }
  end
end
