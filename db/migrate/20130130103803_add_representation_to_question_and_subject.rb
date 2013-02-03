class AddRepresentationToQuestionAndSubject < ActiveRecord::Migration
  def change
    add_column :questions, :representation, :text
    add_column :ar_exercises, :representation, :text
  end
end
