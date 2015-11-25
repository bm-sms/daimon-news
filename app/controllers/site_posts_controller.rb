class SitePostsController < ApplicationController
  before_action :setup_site

  def index
    @posts = @site.posts
  end

  def show
    @post = @site.posts.find(params[:id])
  end

  private
  def setup_site
    @site = Site.find(params[:site_id])
  end
end
