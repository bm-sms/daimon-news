class AddColumnsToStoreProgress < ActiveRecord::Migration
  def change
    add_column :posts, :progress_html, :text
    add_column :posts, :base_html, :text
  end
end
