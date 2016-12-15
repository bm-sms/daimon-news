class PartialsController < ApplicationController
  skip_after_action :verify_same_origin_request

  def pickup_posts
    render partial: 'application/pickup_posts', layout: false, locals: {pickup_posts: current_site.pickup_posts}
  end
end
