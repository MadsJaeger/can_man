class CreateRights < ActiveRecord::Migration[7.0]
  def change
    create_table :rights, id: false, comment: 'List of controller actions to be linked to users as her rights' do |t|
      t.string  :key, primary_key: true
      t.string  :name, null: true, comment: 'Name of the right, descriptive name potentially to be used in the UI'
      t.text    :description, null: true, comment: 'Description of the right, potentially to be used in the UI'
      t.timestamps

      t.index :key, unique: true
    end
  end
end
