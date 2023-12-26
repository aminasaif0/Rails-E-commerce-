module RoleCheck
  extend ActiveSupport::Concern
  def has_role?(role)
    roles.exists?(name: role)
  end
end
