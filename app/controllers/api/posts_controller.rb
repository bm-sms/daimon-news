class Api::PostsController < Api::ApplicationController
  def index
    scope =
      if params.dig(:filter, :category_slug)
        current_site.categories.find_by!(slug: params[:filter][:category_slug]).posts
      elsif params.dig(:filter, :serial_id)
        current_site.serials.find(params[:filter][:serial_id]).posts
      else
        current_site.posts
      end

    posts = scope.published.order_by_recent.page(params.dig(:page, :number)).per(params.dig(:page, :size))
    render json: posts, include: "category", meta: pagination_meta(posts)
  end

  def show
    post = current_site.posts.published.find_by!(public_id: params[:public_id])

    render json: post, include: "related_posts.category, category, serial"
  end
end
