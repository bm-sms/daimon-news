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
    @site = Site.find(site_id)
  end

  def site_id
    case env['SERVER_NAME']
    when /\Asite1\./
      1
    when /\Asite2\./
      2
    else
      params[:site_id]
    end
  end
end
