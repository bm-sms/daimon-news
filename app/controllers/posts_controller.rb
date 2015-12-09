class PostsController < ApplicationController
  before_action :setup_site

  def index
    @posts = @site.posts.published
  end

  def show
    @post = @site.posts.published.find(params[:id])
  end

  private

  def setup_site
    if params[:site_id]
      # for test and debug
      @site = Site.find(params[:site_id])
    else
      @site = Site.find_by!(fqdn: request.server_name)
    end
  end
end
