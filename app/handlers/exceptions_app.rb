class ExceptionsApp < Rambulance::ExceptionsApp
  helper ApplicationHelper

  helper_method :current_site, :current_category

  def bad_request
  end

  def forbidden
  end

  def not_found
  end

  def internal_server_error
  end

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
end
