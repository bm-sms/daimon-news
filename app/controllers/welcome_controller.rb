class WelcomeController < ApplicationController
  before_action :setup_site

  def index
    @posts  = @site.posts
    @topics = @site.topics
  end
end
