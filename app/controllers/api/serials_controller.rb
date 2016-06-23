class Api::SerialsController < Api::ApplicationController
  def index
    serials = current_site.serials.includes(:posts).order(id: :desc).page(params.dig(:page, :number)).per(params.dig(:page, :size))

    render json: serials
  end

  def show
    serial = current_site.serials.find(params[:id])

    render json: serial
  end
end
