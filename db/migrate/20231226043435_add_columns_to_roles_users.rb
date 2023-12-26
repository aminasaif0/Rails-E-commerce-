class AddColumnsToRolesUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :roles_users, :user_id, :integer, null: false
    add_column :roles_users, :role_id, :integer, null: false

    add_index :roles_users, [:role_id, :user_id], name: 'index_roles_users_on_role_id_and_user_id'
    add_index :roles_users, [:user_id, :role_id], name: 'index_roles_users_on_user_id_and_role_id'
  end
end
