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

  def favicon_tag
    if favicon_image.present?
      favicon_link_tag favicon_image_url
    elsif favicon_url.present?
      favicon_link_tag favicon_url
    end
  end

  def mobile_favicon_tag
    if mobile_favicon_image.present?
      favicon_link_tag(mobile_favicon_image_url,
                       rel: 'apple-touch-icon-precomposed', type: 'image/png')
    elsif mobile_favicon_url.present?
      favicon_link_tag(mobile_favicon_url,
                       rel: 'apple-touch-icon-precomposed', type: 'image/png')
    end
  end
end
