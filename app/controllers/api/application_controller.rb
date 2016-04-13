module Api
  class ApplicationController < ActionController::Base
    protect_from_forgery with: :null_session

    def serialization_scope
      view_context
    end

    def current_site
      @current_site ||= Site.where(opened: true).find_by!(fqdn: params[:site_fqdn])
    end
  end
end
