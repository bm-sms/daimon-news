class Editor::SeriesController < Editor::ApplicationController
  def index
    @series_list = series_list.order(id: :desc)
  end

  def show
    @series = series_list.find(params[:id])
  end

  def new
    @series = series_list.build
  end

  def create
    @series = series_list.build(series_params)

    if @series.save
      redirect_to [:editor, @series], notice: "連載が作成されました"
    else
      render :new
    end
  end

  def edit
    @series = series_list.find(params[:id])
  end

  def update
    @series = series_list.find(params[:id])

    if @series.update(series_params)
      redirect_to [:editor, @series], notice: "連載が更新されました"
    else
      render :edit
    end
  end

  def destroy
    @series = series_list.find(params[:id])

    @series.destroy

    redirect_to editor_series_index_url, notice: "連載が削除されました"
  end

  private

  def series_list
    current_site.series
  end

  def series_params
    params.require(:series).permit(
      :title,
      :description,
      :slug
    )
  end
end
