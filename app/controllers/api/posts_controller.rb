class Api::PostsController < Api::ApplicationController
  def index
    scope = current_site.posts
    scope = scope.joins(:category).merge(Category.where(slug: params[:filter][:category_slug])) if params.dig(:filter, :category_slug)
    scope = scope.where(serial_id: params[:filter][:serial_id])                                 if params.dig(:filter, :serial_id)

    posts = scope.published.order_by_recent.page(params.dig(:page, :number)).per(params.dig(:page, :size))
    render json: posts, include: "category", meta: pagination_meta(posts)
  end

  def show
    post = current_site.posts.published.find_by!(public_id: params[:public_id])

    render json: post, include: "related_posts.category, category, serial"
  end
end
