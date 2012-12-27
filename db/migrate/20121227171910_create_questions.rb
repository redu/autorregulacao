class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.string :title
      t.text :statement
      t.references :ar_exercise

      t.timestamps
    end
    add_index :questions, :ar_exercise_id
  end
end
