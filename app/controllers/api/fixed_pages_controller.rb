class Api::FixedPagesController < Api::ApplicationController
  def show
    fixed_page = current_site.fixed_pages.find_by!(slug: params[:slug])

    render json: fixed_page
  end
end
