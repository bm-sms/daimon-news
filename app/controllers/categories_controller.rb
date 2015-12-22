class CategoriesController < ApplicationController
  def show
    @category = Category.find_by!(slug: params[:id])
    @posts = current_site.posts.where(category: @category).published.order_by_recently.page(params[:page])
  end
end
