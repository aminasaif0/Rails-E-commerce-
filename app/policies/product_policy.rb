# frozen_string_literal: true

class ProductPolicy < ApplicationPolicy
    def index?
      true
    end

    def show?
      true
    end

    def create?
      user&.has_role?('admin')
    end

    def update?
      user&.has_role?('admin')
    end

    def destroy?
      Rails.logger.debug("I was here, I checked destroy policy")

      user&.has_role?('admin')
    end

    class Scope < Scope
      def resolve
        scope.all
      end
    end
  end
