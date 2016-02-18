class Admin::SiteEditorsController < Admin::ApplicationController
  def edit
    @site = Site.find(params[:site_id])
  end

  def update
    @site = Site.find(params[:site_id])

    @site.update!(editors_params)

    redirect_to admin_site_url(@site), notice: 'サイトの編集者が更新されました'
  end

  private

  def editors_params
    params.require(:site).permit(
      :editor_ids => []
    )
  end
end
