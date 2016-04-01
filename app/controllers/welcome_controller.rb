class WelcomeController < ApplicationController
  def index
    @posts = current_site.posts.published.order_by_recently.page(params[:page])

    @posts.extend(PaginationInfoDecorator)
  end
end
