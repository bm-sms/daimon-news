class Editor::ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  layout 'editor'

  before_action :authenticate_user!
  before_action -> { redirect_to root_url unless current_user.editor_of?(current_site)  }

  include CurrentResourceHelper
end
