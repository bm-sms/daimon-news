class FixedPagesController < ApplicationController
  def show
    @fixed_page = current_site.fixed_pages.find_by!(slug: params[:slug])
  end
end
