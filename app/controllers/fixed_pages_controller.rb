class FixedPagesController < ApplicationController
  before_action :setup_site

  def show
    @fixed_page = @site.fixed_pages.find_by!(slug: params[:id])
  end
end
