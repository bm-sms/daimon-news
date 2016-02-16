class RobotsController < ApplicationController
  skip_before_action :authenticate_user!
  skip_before_action :authorize_user!

  def show
  end
end
