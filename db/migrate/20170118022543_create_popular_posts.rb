class CreatePopularPosts < ActiveRecord::Migration
  def change
    create_table :popular_posts do |t|
      t.references :site, index: true, foreign_key: true, null: false
      t.integer :rank, null: false
      t.references :post, index: true, foreign_key: true, null: false

      t.timestamps null: false
    end
    add_index :popular_posts, [:site_id, :rank]
  end
end
