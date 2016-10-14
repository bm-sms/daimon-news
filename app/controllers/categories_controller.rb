class CategoriesController < ApplicationController
  helper_method :current_category

  def show
    @category = current_site.categories.find_by!(slug: params[:slug])
    @posts = current_site.posts.categorized_by(@category).published.order_by_recent.page(params[:page])
    page_not_found_error! if @posts.blank?
    @posts.extend(PaginationInfoDecorator)
  end

  private

  def current_category
    @category
  end
end
