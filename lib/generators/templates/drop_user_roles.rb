class DropUserRoles < ActiveRecord::Migration<%= migration_version%>
  def up
    remove_foreign_key :user_roles, :roles
    remove_foreign_key :user_roles, :users
    drop_table :user_roles
  end

  def down
    raise NotImplementedError, 'Implement down method by pasting in table definition of dropped table here'
  end
end
