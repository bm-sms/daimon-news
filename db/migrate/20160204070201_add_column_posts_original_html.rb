class AddColumnPostsOriginalHtml < ActiveRecord::Migration
  def change
    add_column :posts, :original_html, :text
  end
end
