class AddOriginalIdToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :original_id, :integer
    add_index :posts, %i(site_id original_id), unique: true
  end
end
