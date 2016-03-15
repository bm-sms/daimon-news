class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  with_options unless: -> { current_site.opened? } do
    before_action :authenticate_user!
    before_action :authorize_user!, if: :current_user
  end

  include CurrentResourceHelper

  private

  def access_denied(exception)
    # FIXME Should we render 404 error page?
    redirect_to root_url
  end

  def routing_error!
    raise ActionController::RoutingError, %|(No route matches [GET] "#{request.path}")|
  end

  def authorize_user!
    head :forbidden unless current_user.admin? || current_user.editor_of?(current_site)
  end
end
