class CreateUserRoles < ActiveRecord::Migration[7.0]
  def change
    create_table :user_roles, comment: 'Join between user and roles' do |t|
      t.references :user, null: false, foreign_key: true, index: true
      t.string :role_key, null: false, index: true
      t.timestamps

      t.index [:user_id, :role_key], unique: true
    end

    add_foreign_key :user_roles, :roles, column: :role_key, primary_key: :key, on_delete: :cascade
  end
end
