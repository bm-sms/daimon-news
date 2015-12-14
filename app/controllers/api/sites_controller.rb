class Api::SitesController < ApplicationController
  protect_from_forgery with: :null_session

  def update
    Site.find(params[:id]).update!(params.require(:site).permit(:js_url, :css_url))

    head :ok
  end
end
