class Api::PostsController < Api::ApplicationController
  def index
    scope =
      if params.dig(:filter, :category_slug)
        current_site.categories.find_by!(slug: params[:filter][:category_slug]).posts
      else
        current_site.posts
      end

    posts = scope.published.order_by_recently.page(params.dig(:page, :number)).per(params.dig(:page, :size))
    render json: posts, include: "category", meta: pagination_meta(posts)
  end

  def show
    post = current_site.posts.published.find(params[:id])

    render json: post, include: "related_posts.category, next_post.category, previous_post.category, category"
  end
end
