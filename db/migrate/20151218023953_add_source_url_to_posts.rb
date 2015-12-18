class AddSourceUrlToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :source_url, :string
  end
end
