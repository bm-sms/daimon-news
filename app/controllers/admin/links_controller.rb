class Admin::LinksController < Admin::ApplicationController
  def index
    @links = links
  end

  def show
    @link = links.find(params[:id])
  end

  def new
    @link = links.build
  end

  def create
    @link = links.build(link_params)

    if @link.save
      redirect_to [:admin, current_site, @link], notice: 'リンクが作成されました'
    else
      render :new
    end
  end

  def edit
    @link = links.find(params[:id])
  end

  def update
    @link = links.find(params[:id])

    if @link.update(link_params)
      redirect_to [:admin, current_site, @link], notice: 'リンクが更新されました'
    else
      render :edit
    end
  end

  def destroy
    @link = links.find(params[:id])

    @link.destroy

    redirect_to admin_site_links_url, notice: 'リンクが削除されました'
  end

  private

  def links
    current_site.links
  end

  def link_params
    params.require(:link).permit(
      :text,
      :url,
      :order
    )
  end

  def current_site
    @current_site ||= Site.find(params[:site_id])
  end
end
