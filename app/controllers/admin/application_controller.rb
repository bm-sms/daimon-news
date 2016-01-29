class Admin::ApplicationController < ApplicationController
  layout 'admin'

  before_action :authenticate_user!
end
