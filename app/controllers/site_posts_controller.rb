class SitePostsController < ApplicationController
  def index
    @site = Site.find(params[:site_id])

    render json: @site.posts.as_json(except: [:site_id])
  end

  def show
    @post = Site.find(params[:site_id]).posts.find(params[:id])

    render json: @post.as_json(except: [:site_id])
  end
end
