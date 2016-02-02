class MigratePostsOriginalIdToId < ActiveRecord::Migration
  def up
    execute 'UPDATE posts SET id = original_id'

    remove_column :posts, :original_id
  end

  def down
    # This migration couldn't be rollbacked correctly.

    add_column :posts, :original_id, :integer

    add_index :posts, [:published_at, :original_id]
    add_index :posts, [:site_id, :original_id], unique: true

    execute 'UPDATE posts SET original_id = id'
  end
end
