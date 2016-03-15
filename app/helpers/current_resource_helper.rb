module CurrentResourceHelper
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
