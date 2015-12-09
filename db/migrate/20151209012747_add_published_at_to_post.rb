class AddPublishedAtToPost < ActiveRecord::Migration
  def change
    add_column :posts, :published_at, :datetime
    add_column :posts, :published, :boolean
  end
end
