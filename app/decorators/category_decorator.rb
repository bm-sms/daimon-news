module CategoryDecorator
  def to_og_params
    {
      locale: "ja_JP",
      type: "object",
      title: [name, site.tagline, site.name].select(&:present?).join(" | "),
      description: MetaTags::TextNormalizer.normalize_description(render_markdown(description)),
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
    if site.category_title_format.present?
      title = site.category_title_format % {category_name: name}
    else
      title = name
    end
    if posts.current_page > 1
      "#{title} (#{posts.page_entries_info})"
    else
      title
    end
  end

  def highlighted?(current_category)
    return false unless current_category
    root_of?(current_category)
  end
end
