module CategoryDecorator
  def to_og_params
    {
      locale: "ja_JP",
      type: "object",
      title: [name, site.tagline, site.name].select(&:present?).join(" | "),
      description: MetaTags::TextNormalizer.normalize_description(description),
      url: category_url(slug),
      site_name: site.name,
      image: site.logo_image_url
    }
  end

  def canonical_url(posts)
    if posts.current_page > 1
      category_url(page: posts.current_page)
    else
      category_url
    end
  end

  def page_title(posts)
    if posts.current_page > 1
      "#{name} (#{posts.page_entries_info})"
    else
      name
    end
  end
end
