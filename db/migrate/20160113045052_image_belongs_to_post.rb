class ImageBelongsToPost < ActiveRecord::Migration
  def change
    add_column :images, :post_id, :integer
    add_foreign_key :images, :posts
  end
end
