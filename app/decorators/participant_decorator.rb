module ParticipantDecorator
  def to_og_params
    {
      locale: "ja_JP",
      type: "object",
      title: [name, site.tagline, site.name].select(&:present?).join(" | "),
      description: MetaTags::TextNormalizer.normalize_description(render_markdown(description)),
      url: participant_url(self),
      site_name: site.name,
      image: site.logo_image_url
    }
  end

  def canonical_url(posts)
    if posts.current_page > 1
      participant_url(self, page: posts.current_page)
    else
      participant_url(self)
    end
  end

  def page_title(posts)
    if posts.current_page > 1
      "#{name} (#{posts.page_entries_info})"
    else
      name
    end
  end

  def number_of_posts(posts)
    "記事数：#{posts.size}"
  end
end
