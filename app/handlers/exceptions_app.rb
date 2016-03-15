class ExceptionsApp < Rambulance::ExceptionsApp
  include CurrentResourceHelper

  helper ApplicationHelper
  helper CurrentResourceHelper

  def not_found
    respond_to do |format|
      format.any { render(formats: :html, content_type: 'text/html', layout: 'error') }
    end
  end

  def internal_server_error
  end

  def unprocessable_entity
  end
end
