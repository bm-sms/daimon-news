class ExceptionsApp < Rambulance::ExceptionsApp
  include CurrentResouceHelper

  helper ApplicationHelper
  helper CurrentResouceHelper

  def bad_request
  end

  def forbidden
  end

  def not_found
  end

  def internal_server_error
  end
end
