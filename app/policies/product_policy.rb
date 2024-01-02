# frozen_string_literal: true

class ProductPolicy < ApplicationPolicy
    def index?
      true
    end

    def show?
      true
    end

    def create?
      user&.isAdmin?
    end

    def update?
      user&.isAdmin?
    end

    def destroy?
      user&.isAdmin?
    end

    def add_to_cart?
      true
    end

    def autocomplete?
      true
    end

    class Scope < Scope
      def resolve
        scope.all
      end
    end
  end
