class AddNullConstraintToPostThumbnail < ActiveRecord::Migration
  def up
    change_column :posts, :thumbnail, :string, null: false
  end

  def down
    change_column :posts, :thumbnail, :string, null: true
  end
end
