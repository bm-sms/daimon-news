class WelcomeController < ApplicationController
  def index
    @posts = current_site.posts.includes(:categories).published.order_by_recent.page(params[:page])
    page_not_found_error! if @posts.blank?
    @posts.extend(PaginationInfoDecorator)
  end
end
