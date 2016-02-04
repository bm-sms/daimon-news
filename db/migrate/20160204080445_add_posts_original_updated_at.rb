class AddPostsOriginalUpdatedAt < ActiveRecord::Migration
  def change
    add_column :posts, :original_updated_at, :datetime

    execute 'UPDATE posts SET original_updated_at = updated_at'
  end
end
