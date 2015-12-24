class AddIndexPostsPublishedAt < ActiveRecord::Migration
  def change
    add_index :posts, [:published_at, :original_id]
  end
end
