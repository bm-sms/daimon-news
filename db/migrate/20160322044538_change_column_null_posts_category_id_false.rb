class ChangeColumnNullPostsCategoryIdFalse < ActiveRecord::Migration
  def change
    change_column_null :posts, :category_id, false
  end
end
