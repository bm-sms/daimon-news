module CategoryDecorator
  def to_og_params
    {
      locale: 'ja_JP',
      type: 'object',
      title: [name, site.tagline, site.name].select(&:present?).join(' | '),
      description: MetaTags::TextNormalizer.normalize_description(description),
      url: category_url(slug),
      site_name: site.name,
      image: site.logo_image_url
    }
  end
end
