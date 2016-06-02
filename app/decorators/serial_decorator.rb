module SerialDecorator
  def to_og_params
    {
      locale: "ja_JP",
      type: "object",
      title: [title, site.tagline, site.name].select(&:present?).join(" | "),
      description: MetaTags::TextNormalizer.normalize_description(render_markdown(description)),
      url: serial_url(self),
      site_name: site.name,
      image: site.logo_image_url
    }
  end

  def canonical_url(posts)
    if posts.current_page > 1
      serial_url(self, page: posts.current_page)
    else
      serial_url(self)
    end
  end

  def page_title(posts)
    if posts.current_page > 1
      "#{title} (#{posts.page_entries_info})"
    else
      title
    end
  end

  def number_of_posts(posts)
    "記事数：#{posts.size}"
  end
end
