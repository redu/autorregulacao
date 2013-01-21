class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.string :login
      t.string :name
      t.string :token
      t.integer :uid

      t.timestamps
    end
  end
end
