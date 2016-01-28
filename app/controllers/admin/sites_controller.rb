class Admin::SitesController < Admin::ApplicationController
  def edit
    @site = current_site
  end

  def update
    @site = current_site

    # TODO Update

    redirect_to [:admin, :root], notice: 'サイト情報が更新されました。'
  end
end
