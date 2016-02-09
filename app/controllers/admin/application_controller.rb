class Admin::ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  layout 'admin'

  before_action :authenticate_user!
  before_action -> { redirect_to root_path unless current_user.admin?  }

  helper_method :current_site

  def current_site
    nil
  end
end
