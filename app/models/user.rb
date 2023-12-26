class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  include RoleCheck

  has_many :addresses
  has_many :orders
  has_one :cart
  has_many :roles_users
  has_many :roles, through: :roles_users
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  after_create :assign_default_role

  private
  def assign_default_role
    role = Role.find_by(name: 'User')
    self.roles << role if role
  end
end
