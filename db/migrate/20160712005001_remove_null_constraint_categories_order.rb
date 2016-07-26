class RemoveNullConstraintCategoriesOrder < ActiveRecord::Migration
  def up
    change_column :categories, :order, :integer, null: true
  end

  def down
    change_column :categories, :order, :integer, null: false
  end
end
