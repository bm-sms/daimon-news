module SiteDecorator
  def to_og_params
    {
      locale: 'ja_JP',
      type: 'website',
      title: [name, tagline].select(&:present?).join(' | '),
      description: description,
      url: root_url,
      site_name: name,
      image: logo_url
    }
  end

  def js_path
    return js_url if js_url.present?

    'themes/default/application'
  end

  def css_path
    return css_url if css_url.present?
    return custom_css_url if base_color.present?

    'themes/default/application'
  end
end
