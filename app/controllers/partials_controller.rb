class PartialsController < ApplicationController
  skip_after_action :verify_same_origin_request

  def pickup_posts
    render partial: "application/pickup_posts", layout: false, locals: {pickup_posts: current_site.pickup_posts}
  end

  def popular_posts
    render partial: "application/popular_posts", layout: false, locals: {popular_posts: current_site.popular_posts.ordered.limit(current_site.ranking_size)}
  end
end
