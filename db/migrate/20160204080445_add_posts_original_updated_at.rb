class AddPostsOriginalUpdatedAt < ActiveRecord::Migration
  def change
    add_column :posts, :original_updated_at, :datetime
  end
end
