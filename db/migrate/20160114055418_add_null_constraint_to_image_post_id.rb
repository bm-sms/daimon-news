class AddNullConstraintToImagePostId < ActiveRecord::Migration
  def up
    change_column :images, :post_id, :integer, null: false
  end

  def down
    change_column :images, :post_id, :integer, null: true
  end
end
