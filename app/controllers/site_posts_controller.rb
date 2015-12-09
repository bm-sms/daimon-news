class SitePostsController < ApplicationController
  before_action :setup_site
  layout 'site_posts'

  def index
    @posts = @site.posts
  end

  def show
    @post = @site.posts.find(params[:id])
  end

  private

  def setup_site
    if params[:site_id]
      # for test and debug
      @site = Site.find(params[:site_id])
    else
      @site = Site.where(fqdn: request.server_name).first
    end
  end
end
