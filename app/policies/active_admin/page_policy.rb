module ActiveAdmin
  class PagePolicy < ApplicationPolicy
    attr_reader :user, :record

    def initialize(user, record)
      @user = user
      @record = record
    end

    def show?
      case record.name
      when "Dashboard"
        true
      else
        @user.admin?
      end
    end

    class Scope
      attr_reader :user, :scope

      def initialize(user, scope)
        @user = user
        @scope = scope
      end

      def resolve
        scope
      end
    end
  end
end
