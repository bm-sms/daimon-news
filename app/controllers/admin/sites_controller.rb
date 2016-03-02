class Admin::SitesController < Admin::ApplicationController
  def index
    @sites = Site.all
  end

  def new
    @site = Site.new
  end

  def show
    @site = Site.find(params[:id])
  end

  def create
    @site = Site.new(site_params)

    if @site.valid?
      @site.transaction do
        @site.save!
        @site.memberships.create!(user: current_user)
      end

      redirect_to [:admin, @site], notice: 'サイトが作成されました。'
    else
      render :new
    end
  end

  def edit
    @site = current_site
  end

  def update
    @site = current_site

    if @site.update(site_params)
      redirect_to [:admin, @site], notice: 'サイト情報が更新されました。'
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
      :mobile_favicon_image,
      :head_tag,
      :promotion_tag
    )
  end

  def current_site
    return nil unless params.key?(:id)

    @current_site ||= Site.find(params[:id])
  end
end
