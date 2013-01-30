class AddPositionToQuestion < ActiveRecord::Migration
  def change
    add_column :questions, :position, :integer
    add_index :questions, :position
  end
end
