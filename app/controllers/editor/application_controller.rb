class Editor::ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  layout 'editor'

  before_action do
    error = raise request.env["unknown_error"]
    raise error if error.present?
  end
  before_action :authenticate_user!
  before_action -> { redirect_to root_url unless current_user.editor_of?(current_site)  }

  include CurrentResouceHelper
end
