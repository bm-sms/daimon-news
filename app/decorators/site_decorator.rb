module SiteDecorator
  def to_og_params
    {
      locale: 'ja_JP',
      type: 'website',
      title: [name, tagline].select(&:present?).join(' | '),
      description: description&.gsub("\n", ''),
      url: root_url,
      site_name: name,
      image: logo_url
    }
  end
end
