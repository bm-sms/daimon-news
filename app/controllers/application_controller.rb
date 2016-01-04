class ApplicationController < ActionController::Base
  include Pundit
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  http_basic_authenticate_with name: ENV['DIGEST_AUTH_USERNAME'], password: ENV['DIGEST_AUTH_PASSWORD'] if Rails.env.production?

  helper_method :current_site, :current_category

  private

  def current_site
    @current_site ||=
      if params[:site_id]
        # for test and debug
        Site.find(params[:site_id])
      else
        Site.find_by!(fqdn: request.server_name)
      end
  end

  def current_category
    nil
  end

  def access_denied(exception)
    # FIXME Should we render 404 error page?
    redirect_to root_path
  end

  def routing_error!
    raise ActionController::RoutingError, %|(No route matches [GET] "#{request.path}")|
  end
end
