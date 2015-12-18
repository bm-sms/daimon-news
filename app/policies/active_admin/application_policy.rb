module ActiveAdmin
  class ApplicationPolicy < ::ApplicationPolicy
    def index?
      @user.admin? || @user.site_owner?
    end

    def show?
      @user.admin? || @user.site_owner?
    end

    def create?
      @user.admin? || @user.site_owner?
    end

    def new?
      create?
    end

    def update?
      @user.admin? || @user.site_owner?
    end

    def edit?
      @user.admin? || @user.site_owner?
    end

    def destroy?
      @user.admin? || @user.site_owner?
    end
  end
end
