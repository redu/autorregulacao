class CreateSpaces < ActiveRecord::Migration
  def change
    create_table :spaces do |t|
      t.integer :core_id
      t.string :name

      t.timestamps
    end
  end
end
