class RenameOriginalHtmlToOriginalSource < ActiveRecord::Migration
  def change
    rename_column :posts, :original_html, :original_source
  end
end
