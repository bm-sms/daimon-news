class WelcomeController < ApplicationController
  before_action :setup_site

  def index
    @posts  = @site.posts
    @topics = @site.topics if @site.bbs_enabled?
  end
end
