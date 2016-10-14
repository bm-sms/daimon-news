class SerialsController < ApplicationController
  def index
    @serials = current_site.serials.published.order_by_recent.page(params[:page])
    page_not_found_error! if @serials.blank?
    @serials.extend(SerialsDecorator)
  end

  def show
    @serial = current_site.serials.find(params[:id])
    @posts = current_site.posts.where(serial: @serial).published.order_by_recent.page(params[:page])
    page_not_found_error! if @posts.blank?

    @posts.extend(PaginationInfoDecorator)
  end
end
