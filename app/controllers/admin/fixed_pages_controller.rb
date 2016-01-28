class Admin::FixedPagesController < Admin::ApplicationController
  def index
    @fixed_pages = fixed_pages
  end

  def show
    @fixed_page = fixed_pages.find(params[:id])
  end

  def new
    @fixed_page = fixed_pages.build
  end

  def create
    @fixed_page = fixed_pages.build(fixed_page_params)

    if @fixed_page.save
      redirect_to [:admin, @fixed_page], notice: '固定ページが作成されました'
    else
      render :new
    end
  end

  def edit
    @fixed_page = fixed_pages.find(params[:id])
  end

  def update
    @fixed_page = fixed_pages.find(params[:id])

    if @fixed_page.update(fixed_page_params)
      redirect_to [:admin, @fixed_page], notice: '固定ページが更新されました'
    else
      render :edit
    end
  end

  def destroy
    @fixed_page = fixed_pages.find(params[:id])

    @fixed_page.destroy

    redirect_to admin_fixed_pages_url, notice: '固定ページが削除されました'
  end

  private
  def fixed_pages
    current_site.fixed_pages
  end

  def fixed_page_params
    params.require(:fixed_page).permit(
      :title,
      :body,
      :slug
    )
  end
end
