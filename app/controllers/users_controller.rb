class UsersController < ApplicationController
    before_action :authenticate_admin!

    def index
        @users = User.includes(:roles)
    end
    private

  def authenticate_admin!
    redirect_to root_path, alert: 'Access denied.' unless current_user&.has_role?('admin')
  end
end
