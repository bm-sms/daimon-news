class PostsController < ApplicationController
  def show
    @post = current_site.posts.published.find(params[:id])
    @pages = Kaminari.paginate_array(@post.pages).page(params[:page]).per(1)
  end
end
