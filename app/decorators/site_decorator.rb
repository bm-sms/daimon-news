module SiteDecorator
  def to_og_params
    {
      locale: "ja_JP",
      type: "website",
      title: [name, tagline].select(&:present?).join(" | "),
      description: MetaTags::TextNormalizer.normalize_description(description),
      url: root_url,
      site_name: name,
      image: logo_image_url
    }
  end

  def canonical_url(posts)
    if posts.current_page > 1
      root_url(page: posts.current_page)
    else
      root_url
    end
  end

  def serials_canonical_url(serials)
    if serials.current_page > 1
      serials_url(page: serials.current_page)
    else
      serials_url
    end
  end

  def participants_canonical_url(participants)
    if participants.current_page > 1
      participants_url(page: participants.current_page)
    else
      participants_url
    end
  end

  def page_title(posts)
    if posts.current_page > 1
      "#{tagline} (#{posts.page_entries_info})"
    else
      tagline
    end
  end
end
