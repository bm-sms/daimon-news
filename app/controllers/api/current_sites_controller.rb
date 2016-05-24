class Api::CurrentSitesController < Api::ApplicationController
  def show
    render json: current_site, include: ["categories", "links"]
  end
end
