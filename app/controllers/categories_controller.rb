class CategoriesController < ApplicationController
  before_action :setup_site

  def show
    @category = Category.find_by!(slug: params[:id])
    @posts = @site.posts.where(category: @category)

    render 'posts/index'
  end
end
