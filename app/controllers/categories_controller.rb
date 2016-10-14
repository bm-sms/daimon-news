class CategoriesController < ApplicationController
  helper_method :current_category

  def show
    @category = current_site.categories.find_by!(slug: params[:slug])
    @posts = current_site.posts.categorized_by(@category).published.order_by_recent.page(params[:page])
    validate_page_params(params[:page], @posts.total_pages)
    @posts.extend(PaginationInfoDecorator)
  end

  private

  def current_category
    @category
  end
end
