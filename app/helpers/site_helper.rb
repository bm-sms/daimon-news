module SiteHelper
  def site_js_location(site)
    site.js_url.presence || "themes/default/application"
  end

  def site_css_location(site)
    asset_host = Rails.application.config.action_controller.asset_host

    url_options = {}
    url_options[:digest] = Digest::MD5.hexdigest(["site-css", site.base_hue, "layout-version"].join(":")) # TODO: Add layout-version API to layout gem. And use it.
    url_options[:host] = asset_host if asset_host.present?

    site.css_url.presence || (site.base_hue? ? custom_css_url(site.fqdn, url_options) : "themes/default/application")
  end
end
