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
    @site = DaimonNewsAdmin::Site.find(site_id)
  end

  def site_id
    # NOTE: env['SERVER_NAME'] よりも、 request.domain や
    #       request.subdomain のほうがいいかもしれない。
    # 例: http://site1.lvh.me/ の場合
    #   * env['SERVER_NAME']  #=> site1.lvh.me
    #   * request.domain      #=> lvh.me
    #   * request.subdomain   #=> site1
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
