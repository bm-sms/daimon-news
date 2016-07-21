class CategoriesController < ApplicationController
  helper_method :current_category

  def show
    @category = current_site.categories.find_by!(slug: params[:id])
    @posts = current_site.posts.categorized(@category).published.order_by_recent.page(params[:page])

    @posts.extend(PaginationInfoDecorator)
  end

  private

  def current_category
    @category
  end
end
