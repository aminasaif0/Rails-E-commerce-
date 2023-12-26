class AddTableRolesUser < ActiveRecord::Migration[7.1]
  def change
    create_table :roles_users do |t|
      t.integer :user_id, null: false
      t.integer :role_id, null: false

      t.index [:role_id, :user_id], name: 'index_roles_users_on_role_id_and_user_id'
      t.index [:user_id, :role_id], name: 'index_roles_users_on_user_id_and_role_id'
      t.timestamps
    end
  end
end
