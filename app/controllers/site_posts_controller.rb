class SitePostsController < ApplicationController
  def index
    @site = Site.find(params[:site_id])
    @posts = @site.posts
  end

  def show
    @post = Site.find(params[:site_id]).posts.find(params[:id])
  end
end
