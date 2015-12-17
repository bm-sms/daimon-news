class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_site

  private

  def current_site
    current_site ||=
      if params[:site_id]
        # for test and debug
        Site.find(params[:site_id])
      else
        Site.find_by!(fqdn: request.server_name)
      end
  end

  def routing_error!
    raise ActionController::RoutingError, %|(No route matches [GET] "#{request.path}")|
  end
end
