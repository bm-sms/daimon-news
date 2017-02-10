class WelcomeController < ApplicationController
  def index
    @posts = current_site.posts.includes(:categories).published.order_by_recent.page(params[:page])
    validate_page_params(params[:page], @posts.total_pages)
    @top_fixed_posts = current_site.posts.includes(:categories).published.fixed
    @posts.extend(PaginationInfoDecorator)
  end
end
