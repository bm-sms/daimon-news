class RemoveDataTransferColumns < ActiveRecord::Migration
  def change
    remove_column :posts, :original_source, :text
    remove_column :posts, :original_html, :text
    remove_column :posts, :stripped_html, :text
    remove_column :posts, :replaced_html, :text
    remove_column :posts, :source_url, :string
  end
end
