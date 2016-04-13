module Api
  class ApplicationController < ActionController::Base
    protect_from_forgery with: :null_session

    def serialization_scope
      view_context
    end
  end
end
