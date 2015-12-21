class AddThumbnailUrlToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :thumbnail_url, :string
  end
end
