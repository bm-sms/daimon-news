module Api
  class PostsController < ApplicationController
    def show
      post = current_site.posts.published.find(params[:id])

      render json: post, include: 'related_posts'
    end

    private

    def current_site
      @current_site ||= Site.where(opened: true).find_by!(fqdn: params[:site_fqdn])
    end
  end
end
