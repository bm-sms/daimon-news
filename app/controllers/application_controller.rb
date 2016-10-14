class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  with_options unless: -> { current_site.opened? } do
    before_action :authenticate_user!
    before_action :authorize_user!, if: :current_user
  end

  class PageNotFound < StandardError; end

  include CurrentResourceHelper

  private

  def routing_error!
    raise ActionController::RoutingError, %|(No route matches [GET] "#{request.path}")|
  end

  def validate_page_params(page_param, total_pages)
    raise PageNotFound if page_param.to_i > total_pages
  end

  def authorize_user!
    head :forbidden unless current_user.admin? || current_user.editor_of?(current_site)
  end
end
