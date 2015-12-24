class ChangeColumnNullPostsOriginalIdFalse < ActiveRecord::Migration
  def up
    execute 'UPDATE posts SET original_id = id WHERE original_id IS NULL'

    change_column_null :posts, :original_id, false
  end

  def down
    change_column_null :posts, :original_id, true
  end
end
