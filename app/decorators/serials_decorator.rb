module SerialsDecorator
  def to_og_params
    {
      locale: "ja_JP",
      type: "object",
      title: [title, site.tagline, site.name].select(&:present?).join(" | "),
      description: MetaTags::TextNormalizer.normalize_description(description),
      url: serial_url(slug),
      site_name: site.name,
      image: site.logo_image_url
    }
  end

  def canonical_url(posts)
    if posts.current_page > 1
      serial_url(page: posts.current_page)
    else
      serial_url
    end
  end

  def page_title(posts)
    if posts.current_page > 1
      "#{title} (#{posts.page_entries_info})"
    else
      title
    end
  end

  def title_with_n_posts(posts)
    "#{title} (#{posts.size})"
  end
end