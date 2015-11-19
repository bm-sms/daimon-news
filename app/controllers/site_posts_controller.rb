class SitePostsController < ApplicationController
  layout :layout_name

  def index
    @site = Site.find(params[:site_id])
    @posts = @site.posts
  end

  def show
    @post = Site.find(params[:site_id]).posts.find(params[:id])
  end

  private
  def layout_name
    "site#{@site.id}"
  end
end
