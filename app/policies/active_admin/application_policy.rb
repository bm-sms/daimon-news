module ActiveAdmin
  class ApplicationPolicy < ::ApplicationPolicy
    def index?
      @user.admin? || @user.site_owner?
    end
  end
end
