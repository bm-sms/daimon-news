class Api::ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session

  private

  def serialization_scope
    view_context
  end

  def current_site
    @current_site ||= Site.where(opened: true).find_by!(fqdn: params[:site_fqdn])
  end

  def pagination_meta(object)
    {
      total_count: object.total_count
    }
  end
end
