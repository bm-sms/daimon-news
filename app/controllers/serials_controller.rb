class SerialsController < ApplicationController
  def index
    @serials = current_site.serials.published.order_by_recent.page(params[:page])
    validate_page_params(params[:page], @serials.total_pages)
    @serials.extend(SerialsDecorator)
  end

  def show
    @serial = current_site.serials.find(params[:id])
    @posts = current_site.posts.where(serial: @serial).published.order_by_recent.page(params[:page])
    validate_page_params(params[:page], @posts.total_pages)
    @posts.extend(PaginationInfoDecorator)
  end
end
