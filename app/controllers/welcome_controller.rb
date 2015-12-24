class WelcomeController < ApplicationController
  def index
    @posts  = current_site.posts.published.order_by_recently.page(params[:page])
  end
end
