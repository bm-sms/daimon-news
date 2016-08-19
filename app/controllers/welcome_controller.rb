class WelcomeController < ApplicationController
  def index
    @posts = current_site.posts.includes(:categories).published.order_by_recent.page(params[:page])

    @posts.extend(PaginationInfoDecorator)
  end
end
