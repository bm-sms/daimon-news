class AddThumbnailToSerials < ActiveRecord::Migration
  def up
    execute "UPDATE posts SET serial_id = NULL"
    execute "DELETE FROM serials"

    add_column :serials, :thumbnail, :string, null: false
  end

  def down
    remove_column :serials, :thumbnail
  end
end
