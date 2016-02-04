class AddPostsOriginalUpdatedAt < ActiveRecord::Migration
  def change
    add_column :posts, :original_updated_at, :datetime

    reversible do |dir|
      dir.up { execute 'UPDATE posts SET original_updated_at = updated_at' }
    end
  end
end
