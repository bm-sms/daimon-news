class AddColumnsToStoreProgress < ActiveRecord::Migration
  def change
    add_column :posts, :original_html, :text
    add_column :posts, :stripped_html, :text
    add_column :posts, :replaced_html, :text
  end
end
