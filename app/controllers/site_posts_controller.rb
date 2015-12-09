class SitePostsController < ApplicationController
  before_action :setup_site
  layout 'site_posts'

  def index
    @posts = @site.posts.where(["published_at <= :now ",
                                 { now: DateTime.now }])
  end

  def show
    @post = @site.posts.where(["id = :id AND published_at <= :now",
                                { id: params[:id], now: DateTime.now }]).first!
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
