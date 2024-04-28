class CreateRoleRights < ActiveRecord::Migration<%= migration_version%>
  def change
    create_table :role_rights, comment: 'Join between roles and rights' do |t|
      t.string :role_key, null: false, index: true
      t.string :right_key, null: false, index: true
      t.timestamps

      t.index [:role_key, :right_key], unique: true
    end

    add_foreign_key :role_rights, :roles, column: :role_key, primary_key: :key, on_delete: :cascade
    add_foreign_key :role_rights, :rights, column: :right_key, primary_key: :key, on_delete: :cascade
  end
end
