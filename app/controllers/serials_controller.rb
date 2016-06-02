class SerialsController < ApplicationController
  def index
    @serials = current_site.serials.order(id: :desc)
  end

  def show
    @serial = current_site.serials.find(params[:id])
    @posts = current_site.posts.where(serial: @serial).published.order_by_recently.page(params[:page])

    @posts.extend(PaginationInfoDecorator)
  end
end
