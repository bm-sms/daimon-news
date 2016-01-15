class AddThumbnailImageToPost < ActiveRecord::Migration
  def change
    add_column :posts, :thumbnail_image, :string
  end
end
