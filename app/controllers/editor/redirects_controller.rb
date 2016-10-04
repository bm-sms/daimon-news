class Editor::RedirectsController < Editor::ApplicationController

  def index
    @redirects = redirects
  end

  def show
    @redirect = redirects.find(params[:id])
  end

  def new
    @redirect = redirects.build
  end

  def create
    @redirect = redirects.build(redirect_params)

    if @redirect.save
      redirect_to [:editor, @redirect], notice: "リダイレクトが作成されました"

    else
      render :new
    end
  end

  def edit
    @redirect = redirects.find(params[:id])
  end

  def update
    @redirect = redirects.find(params[:id])

    if @redirect.update(redirect_params)
      redirect_to [:editor, @redirect], notice: "リダイレクトが更新されました"
    else
      render :edit
    end
  end

  def destroy
    @redirect = redirects.find(params[:id])

    @redirect.destroy

    redirect_to editor_redirects_url, notice: "リダイレクトが削除されました"
  end

  private

  def redirects
    current_site.redirects
  end

  def redirect_params
    params.require(:redirect).permit(
      :request,
      :destination
    )
  end
end
