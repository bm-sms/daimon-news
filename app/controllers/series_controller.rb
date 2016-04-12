class SeriesController < ApplicationController
  helper_method :current_series

  def index
    @series_list = current_site.series.order(id: :desc)
  end

  def show
    @series = current_site.series.find_by!(slug: params[:id])
    @posts = current_site.posts.where(series: @series).published.order_by_recently.page(params[:page])

    @posts.extend(PaginationInfoDecorator)
  end

  private

  def current_series
    @series
  end
end
