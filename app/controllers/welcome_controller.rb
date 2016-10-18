class WelcomeController < ApplicationController
  def index
    @posts = current_site.posts.includes(:categories).published.order_by_recent.page(params[:page])
    validate_page_params(params[:page], @posts.total_pages)
    @posts.extend(PaginationInfoDecorator)
  end
end
