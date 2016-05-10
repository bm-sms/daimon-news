class PostsController < ApplicationController
  helper_method :current_category

  def show
    @post = current_site.posts.published.find_by!(public_id: params[:id])
    @serial = current_site.serials.find(@post.serial_id)

    @pages =
      if current_site.view_all? && params[:all]
        @post.pages.page(1).per(@post.pages.size)
      else
        @post.pages.page(params[:page]).per(1)
      end
  end

  private

  def current_category
    @post.category
  end
end
