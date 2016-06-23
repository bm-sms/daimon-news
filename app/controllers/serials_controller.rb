class SerialsController < ApplicationController
  def index
    @serials = current_site.serials.published.order_by_recent.page(params[:page])
    @serials.extend(SerialsDecorator)
  end

  def show
    @serial = current_site.serials.find(params[:id])
    @posts = current_site.posts.where(serial: @serial).published.order_by_recent.page(params[:page])

    @posts.extend(PaginationInfoDecorator)
  end
end
