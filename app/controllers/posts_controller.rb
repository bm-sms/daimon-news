class PostsController < ApplicationController
  before_action :setup_site

  def index
    @posts = @site.posts.published
  end

  def show
    @post = @site.posts.published.find(params[:id])
  end
end
