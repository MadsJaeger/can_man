class DropRoleRights < ActiveRecord::Migration<%= migration_version%>
  def up
    remove_foreign_key :role_rights, :roles
    remove_foreign_key :role_rights, :rights
    drop_table :role_rights
  end

  def down
    raise NotImplementedError, 'Implement down method by pasting in table definition of dropped table here'
  end
end
