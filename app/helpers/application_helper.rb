module ApplicationHelper
  def google_tag_manager(gtm_id)
    if gtm_id.present?
      render partial: 'application/google_tag_manager', locals: { gtm_id: gtm_id }
    end
  end

  def default_meta_tags
    {
      site: current_site.name,
      reverse: true,
      description: current_site.tagline,
    }
  end

  def favicon_tag(site)
    if site.favicon_image.present?
      favicon_link_tag site.favicon_image_url
    elsif site.favicon_url.present?
      favicon_link_tag site.favicon_url
    end
  end

  def mobile_favicon_tag(site)
    if site.mobile_favicon_image.present?
      favicon_link_tag(site.mobile_favicon_image_url,
                       rel: 'apple-touch-icon-precomposed', type: 'image/png')
    elsif site.mobile_favicon_url.present?
      favicon_link_tag(site.mobile_favicon_url,
                       rel: 'apple-touch-icon-precomposed', type: 'image/png')
    end
  end
end
