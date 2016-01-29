class Admin::SitesController < Admin::ApplicationController
  def edit
    @site = current_site
  end

  def update
    @site = current_site

    if @site.update(site_params)
      redirect_to [:admin, :root], notice: 'サイト情報が更新されました。'
    else
      render :edit
    end
  end

  private

  def site_params
    params.require(:site).permit(
      :name,
      :description,
      :js_url,
      :css_url,
      :fqdn,
      :tagline,
      :logo_url,
      :favicon_url,
      :mobile_favicon_url,
      :gtm_id,
      :content_header_url,
      :promotion_url,
      :sns_share_caption,
      :twitter_account,
      :menu_url,
      :home_url,
      :footer_url,
      :ad_client,
      :ad_slot,
      :opened,
      :logo_image,
      :favicon_image,
      :mobile_favicon_image
    )
  end
end
