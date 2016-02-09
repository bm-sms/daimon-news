class Editor::LinksController < Editor::ApplicationController
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
      redirect_to [:editor, @link], notice: 'リンクが作成されました'
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
      redirect_to [:editor, @link], notice: 'リンクが更新されました'
    else
      render :edit
    end
  end

  def destroy
    @link = links.find(params[:id])

    @link.destroy

    redirect_to editor_links_url, notice: 'リンクが削除されました'
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
end
