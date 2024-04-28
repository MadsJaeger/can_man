class CreateRoles < ActiveRecord::Migration[7.0]
  def change
    create_table :roles, id: false, comment: 'Collection of rights' do |t|
      t.string :key, primary_key: true
      t.string :name, null: true, comment: 'Name of the role'
      t.text   :description, null: true, comment: 'Description of the role'
      t.timestamps
    end
  end
end
