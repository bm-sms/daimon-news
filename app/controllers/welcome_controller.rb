class WelcomeController < ApplicationController
  def index
    @posts  = current_site.posts
    @topics = current_site.topics if current_site.bbs_enabled?
  end
end
