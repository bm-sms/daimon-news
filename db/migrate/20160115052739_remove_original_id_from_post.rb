class RemoveOriginalIdFromPost < ActiveRecord::Migration
  def change
    remove_index :posts, column: [:published_at, :original_id]
    remove_index :posts, column: [:site_id, :original_id]
    remove_column :posts, :original_id, :integer
  end
end
