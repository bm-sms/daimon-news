class PostsController < ApplicationController
  def index
    @posts = current_site.posts.published
  end

  def show
    @post = current_site.posts.published.find(params[:id])
  end
end
