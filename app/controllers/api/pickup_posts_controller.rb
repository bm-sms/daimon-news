class Api::PickupPostsController < Api::ApplicationController
  def index
    scope = current_site.pickup_posts
    posts = scope.includes(:post).ordered
    render json: posts, include: "post"
  end
end
