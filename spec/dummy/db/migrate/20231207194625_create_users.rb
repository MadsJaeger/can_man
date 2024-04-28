class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :name, comment: 'Name of the user', null: false
      t.string :email, comment: 'Email of the user', null: false
      t.timestamps
    end
  end
end
