class FeedController < ApplicationController
  def show
    @posts = current_site.posts.published.order_by_recently.preload(:category).limit(20)

    render formats: :xml
  end
end
