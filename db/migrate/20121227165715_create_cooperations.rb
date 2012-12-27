class CreateCooperations < ActiveRecord::Migration
  def change
    create_table :cooperations do |t|
      t.text :rationale
      t.text :recommendation
      t.text :feedback_statement
      t.text :feedback_reflection
      t.boolean :feedback_accepted
      t.references :user
      t.references :answer

      t.timestamps
    end
    add_index :cooperations, :user_id
    add_index :cooperations, :answer_id
  end
end
