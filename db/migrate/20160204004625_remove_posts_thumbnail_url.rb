class RemovePostsThumbnailUrl < ActiveRecord::Migration
  def change
    remove_column :posts, :thumbnail_url, :string
  end
end
