class SitesController < ActionController::Base
  protect_from_forgery with: :exception

  layout "sites"

  before_action :authenticate_user!

  def index
  end

  include CurrentResourceHelper
end
