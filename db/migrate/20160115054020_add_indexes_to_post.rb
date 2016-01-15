class AddIndexesToPost < ActiveRecord::Migration
  def change
    add_index :posts, [:published_at, :id]
    add_index :posts, [:site_id, :id], unique: true
  end
end
