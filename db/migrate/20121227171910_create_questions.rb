class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.string :title
      t.text :statement
      t.references :ar_exercise
      t.integer :core_id

      t.timestamps
    end
    add_index :questions, :ar_exercise_id
    add_index :questions, :core_id
  end
end
