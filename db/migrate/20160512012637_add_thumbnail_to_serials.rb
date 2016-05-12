class AddThumbnailToSerials < ActiveRecord::Migration
  def change
    add_column :serials, :thumbnail, :string, null: false
  end
end
