class Admin::SiteEditorsController < Admin::ApplicationController
  def edit
    @site = current_site
  end

  def update
    @site = current_site

    @site.update!(editors_params)

    redirect_to admin_site_url(@site), notice: 'サイトの編集者が更新されました'
  end

  private

  def editors_params
    params.require(:site).permit(
      :editor_ids => []
    )
  end

  def current_site
    @current_site ||= Site.find(params[:site_id])
  end
end
