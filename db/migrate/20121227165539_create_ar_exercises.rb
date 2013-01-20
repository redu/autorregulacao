class CreateArExercises < ActiveRecord::Migration
  def change
    create_table :ar_exercises do |t|
      t.string :title
      t.references :user
      t.references :space

      t.timestamps
    end
    add_index :ar_exercises, :user_id
    add_index :ar_exercises, :space_id
  end
end
