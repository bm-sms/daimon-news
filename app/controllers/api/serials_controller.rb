class Api::SerialsController < Api::ApplicationController
  def index
    serials = current_site.serials.order(id: :desc).page(params[:page])

    render json: serials
  end

  def show
    serial = current_site.serials.find(params[:id])

    render json: serial
  end
end
