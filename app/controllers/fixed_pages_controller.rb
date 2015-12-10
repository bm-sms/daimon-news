class FixedPagesController < ApplicationController
  before_action :setup_site

  def show
    @post = @site.fixed_pages.find_by!(slug: params[:id])

    render 'posts/show'
  end
end
