class CategoriesController < ApplicationController
  def show
    @category = Category.find_by!(slug: params[:id])
    @posts = current_site.posts.where(category: @category).published

    render 'posts/index'
  end
end
