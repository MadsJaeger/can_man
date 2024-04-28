class DropRoles < ActiveRecord::Migration<%= migration_version%>
  def up
    drop_table :roles
  end

  def down
    raise NotImplementedError, 'Implement down method by pasting in table definition of dropped table here'
  end
end
