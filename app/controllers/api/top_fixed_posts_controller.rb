class Api::TopFixedPostsController < Api::ApplicationController
  def index
    posts = current_site.posts.includes(:categories).published.fixed
    render json: posts, include: "categories"
  end
end
