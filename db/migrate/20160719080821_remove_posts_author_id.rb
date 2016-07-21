class RemovePostsAuthorId < ActiveRecord::Migration
  def change
    remove_column :posts, :author_id, :integer
  end
end
