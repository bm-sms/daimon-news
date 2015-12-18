class PostsController < ApplicationController
  def show
    @post = current_site.posts.published.find(params[:id])
  end
end
