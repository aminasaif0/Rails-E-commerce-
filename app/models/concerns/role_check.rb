module RoleCheck
  extend ActiveSupport::Concern
  def isAdmin?
    roles.exists?(name: 'admin')
  end
end
